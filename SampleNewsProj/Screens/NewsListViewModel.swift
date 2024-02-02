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
    var state: NewsListViewModel.State { get set }

    var rawPosts: [NewsListItem] { get }
    var selectedPost: NewsListItem? { get }
    var showNews: Bool { get set }
    
    func fetchLatestNews()
    func loadMoreNews()
    func hasReachedEndOfList(newsDisplayId: Int) -> Bool
    
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
    @Published var state: State = .loading
    
    var selectedPost: NewsListItem?
    var rawPosts: [NewsListItem] = []
    var adsManager: AdsManager?
            
    private static let perPage: Int = 10
    private var offset: Int = 0
    private var totalNewsCount: Int = 0

    init(newsAPIClient: NewsAPIClientProtocol) {
        self.newsAPI = newsAPIClient
    }
    
    func setupAdsViewController(_ vc: UIViewController) {
        adsManager = AdsManager(rootViewController: vc)
        adsManager?.showAdBanner(showAdsDelegate: self)
    }
 
    func fetchLatestNews() {
        state = .loading
        offset = 0
        
        newsAPI.getLatestPosts(perPage: NewsListViewModel.perPage,
                               offset: self.offset) { [weak self] response in
            DispatchQueue.main.async {
                self?.state = .finished
                
                switch response {
                case .success(let value):
                    self?.rawPosts = value.posts
                    self?.totalNewsCount = value.total
                    self?.offset += value.posts.count
                    
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
    
    func loadMoreNews() {
        guard self.offset != self.totalNewsCount,
              state != .loading else { return }
        
        state = .loading
        
        newsAPI.getLatestPosts(perPage: NewsListViewModel.perPage,
                               offset: self.offset) { [weak self] response in
            DispatchQueue.main.async {
                self?.state = .finished
                
                switch response {
                case .success(let value):
                    self?.rawPosts.append(contentsOf: value.posts)
                    self?.offset += value.posts.count
                    
                    let moreNews = value.posts.map({ item in
                        NewsListItemDisplay(id: item.id, title: item.title, slug: item.slug, imageURLString: item.thumbnail.nano, date: item.date, excerpt: item.excerpt, onSelect: {
                            debugPrint("Show News details of: ", item.slug)
                            self?.selectedPost = item
                            self?.showNews = true
                        })
                    })
                    
                    self?.posts.append(contentsOf: moreNews)
                    debugPrint("posts count: ", self?.posts.count ?? 0)
                case .failure(let aPIError):
                    debugPrint("Error: ", aPIError)
                }
            }
        }
    }
    
    func hasReachedEndOfList(newsDisplayId: Int) -> Bool {
        posts.last?.id == newsDisplayId
    }
}

extension NewsListViewModel: AdsDelegate {
    func addAdsToView(with banner: AdBannerRepresentable) {
        self.banner = banner
    }
}

extension NewsListViewModel {
    enum State {
        case loading
        case finished
    }
}
