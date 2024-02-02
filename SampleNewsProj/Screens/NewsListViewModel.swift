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
    var banner: AdBannerRepresentable? { get set }

    var rawPosts: [NewsListItem] { get }
    var selectedPost: NewsListItem? { get }
    var showNews: Bool { get set }
    
    func fetchLatestNews()
    func setupAdsViewController(_ vc: UIViewController)
}

struct NewsListItemDisplay: Identifiable {
    let id: Int
    let title: String
    let slug: String
    let imageURLString: String
    let date: String
    let excerpt: String
    var onSelect: (() -> ())
}

class NewsListViewModel: NewsListViewModelProtocol {
    private let newsAPI: NewsAPIClientProtocol
    
    @Published var banner: AdBannerRepresentable?
    @Published var posts: [NewsListItemDisplay] = []
    @Published var showNews: Bool = false
    var selectedPost: NewsListItem?
    var rawPosts: [NewsListItem] = []
    var adsManager: AdsManager?
            
    init(newsAPIClient: NewsAPIClientProtocol) {
        self.newsAPI = newsAPIClient
    }
    
    func setupAdsViewController(_ vc: UIViewController) {
        adsManager = AdsManager(rootViewController: vc)
        adsManager?.showAdBanner(showAdsDelegate: self)
    }
 
    func fetchLatestNews() {
        newsAPI.getLatestPosts(perPage: 5) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    self?.rawPosts = value.posts
                    
                    self?.posts = value.posts.map({ item in
                        NewsListItemDisplay(id: item.id, title: item.title, slug: item.slug, imageURLString: item.thumbnail.nano, date: item.date, excerpt: item.excerpt, onSelect: {
                            debugPrint("Show News details of: ", item.slug)
                            self?.selectedPost = item
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

extension NewsListViewModel: AdsDelegate {
    func addAdsToView(with banner: AdBannerRepresentable) {
        self.banner = banner
    }
}
