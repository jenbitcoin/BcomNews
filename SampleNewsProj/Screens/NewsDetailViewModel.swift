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
    let thumbnailURLString: String
    let author: Author
    
    struct Author {
        let avatarURLString: String
        let name: String
        let info: String
    }
}

struct RelatedNewsListItemDisplay: Identifiable {
    let id: Int
    let title: String
    let slug: String
    let imageURLString: String
    let date: String
    var onSelect: (() -> ())
}

protocol NewsDetailViewModelProtocol: ObservableObject {
    var state: ScreenState { get set }
    var news: NewsDisplay? { get set }
    var relatedNews: [RelatedNewsListItemDisplay] { get set }
    var rawNewsListItem: [NewsListItem] { get }
    func fetchNewsDetail()
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {
    private let newsAPI: NewsAPIClientProtocol
    private var newsItem: NewsListItem
    var rawNewsListItem: [NewsListItem] = []

    @Published var state: ScreenState = .loading {
        didSet {
            debugPrint("did set")
        }
    }
    
    var news: NewsDisplay?
    var relatedNews: [RelatedNewsListItemDisplay] = []
    
    init(newsItem: NewsListItem,
         otherNews: [NewsListItem],
         apiClient: NewsAPIClientProtocol) {
        self.newsItem = newsItem
        self.newsAPI = apiClient
        self.rawNewsListItem = otherNews
        
        self.relatedNews = otherNews
            .filter({ $0.id != newsItem.id })
            .map({ item in
            RelatedNewsListItemDisplay(id: item.id,
                                       title: item.title,
                                       slug: item.slug,
                                       imageURLString: item.thumbnail.micro,
                                       date: item.date) {
                self.newsItem = item
                self.fetchNewsDetail()
            }
        })
    }

    func fetchNewsDetail() {
        self.state = .loading
        
        newsAPI.getPostBy(slug: self.newsItem.slug) { [weak self] response in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                switch response {
                case .success(let value):
                    debugPrint(value.content)
                    self.news = NewsDisplay(title: value.title,
                                            content: value.content,
                                            thumbnailURLString: self.newsItem.thumbnail.featured_image,
                                            author: NewsDisplay.Author(avatarURLString: self.newsItem.author.avatar,
                                                                       name: self.newsItem.author.name, 
                                                                       info: self.newsItem.author.info))
                    self.state = .screen
                case .failure(let error):
                    debugPrint("error: ", error.debugDescription(), error.errorDescription())
                    self.state = .error
                }
            }
            
        }
    }
}
