//
//  NewsDetailViewModel.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 1/22/24.
//

import Foundation
import SwiftUI
import UIKit

enum ScreenState {
    case loading
    case screen
    case error
}

struct NewsDisplay {
    let title: String
    let content: String
}

protocol NewsDetailViewModelProtocol: ObservableObject {
    var state: ScreenState { get set }
    var news: NewsDisplay? { get set }
    func fetchNewsDetail()
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {
    private let newsAPI: NewsAPIClientProtocol
    private var slug: String
    
    @Published var state: ScreenState = .loading {
        didSet {
            debugPrint("did set")
        }
    }
    
    var news: NewsDisplay?
    
    init(slug: String,
         apiClient: NewsAPIClientProtocol) {
        self.slug = slug
        self.newsAPI = apiClient
        
        setupSDK()
    }
    
    private func setupSDK() {
        SDKConfiguration.shared.api = SDKAPIData(rootScheme: AppConfig.apiRootScheme,
                                                 rootHost: AppConfig.apiRootHost,
                                                 serverHost: AppConfig.apiServerHost)
    }
    
    func fetchNewsDetail() {
        newsAPI.getPostBy(slug: self.slug) { [weak self] response in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                switch response {
                case .success(let value):
                    debugPrint(value.content)
                    self.news = NewsDisplay(title: value.title, content: value.content)
                    self.state = .screen
                case .failure(let error):
                    debugPrint("error: ", error.debugDescription(), error.errorDescription())
                    self.state = .error
                }
            }
            
        }
    }
}
