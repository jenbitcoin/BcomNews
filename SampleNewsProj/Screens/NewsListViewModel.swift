//
//  NewsListViewModel.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 1/24/24.
//

import Foundation
import SwiftUI
import UIKit

protocol NewsListViewModelProtocol: ObservableObject {
    var posts: [NewsListItemDisplay] { get set }
    var selectedPost: String? { get }
    var showNews: Bool { get set }
    
    func fetchLatestNews()
}

struct NewsListItemDisplay: Identifiable {
    let id = UUID()
    let title: String
    let slug: String
    let date: String
    let excerpt: String
    var onSelect: (() -> ())
}

class NewsListViewModel: NewsListViewModelProtocol {
    private let newsAPI: NewsAPIClientProtocol
    @Published var posts: [NewsListItemDisplay] = []
    @Published var showNews: Bool = false
    var selectedPost: String?
    
    init(newsAPIClient: NewsAPIClientProtocol) {
        self.newsAPI = newsAPIClient
        setupSDK()
    }
    
    private func setupSDK() {
        SDKConfiguration.shared.api = SDKAPIData(rootScheme: AppConfig.apiRootScheme,
                                                 rootHost: AppConfig.apiRootHost,
                                                 serverHost: AppConfig.apiServerHost)
    }
 
    func fetchLatestNews() {
        newsAPI.getLatestPosts(perPage: 5) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    self?.posts = value.posts.map({ item in
                        NewsListItemDisplay(title: item.title, slug: item.slug, date: item.date, excerpt: item.excerpt, onSelect: {
                            debugPrint("Show News details of: ", item.slug)
                            self?.selectedPost = item.slug
                            self?.showNews = true
                        })
                    })
                    debugPrint("posts count: ", self?.posts.count ?? 0)
                case .failure(let aPIError):
                    debugPrint("Error: ", aPIError)
                }
            }
        }
    }
}

