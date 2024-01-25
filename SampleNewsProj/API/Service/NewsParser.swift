//
//  NewsParser.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 01/22/24.
//

import Foundation

public struct AdjacentNews: Codable {
    public struct News: Codable {
        public let id: Int
        public let name: String
        public let slug: String
    }
    
    public let prev: AdjacentNews.News
    public let Next: AdjacentNews.News
}

public struct NewsJSON: Codable {
    public let id: Int
    public let date: String
    public let title: String
    public let slug: String
    public let content: String
    public let adjacent_posts: AdjacentNews
}

public struct NewsAuthor: Codable {
    public let id: String
    public let name: String
    public let slug: String
    public let info: String
    public let avatar: String
}

public struct NewsCategory: Codable {
    public let id: Int
    public let name: String
    public let slug: String
}

public struct NewsThumbnail: Codable {
    public let thumbnail: String
    public let nano: String
    public let micro: String
    public let small: String
    public let medium: String
    public let big: String
    public let large: String
    public let featured_image: String
}

public struct NewsListItem: Codable {
    public let id: Int
    public let date: String
    public let title: String
    public let slug: String
    public let author: NewsAuthor
    public let excerpt: String
    public let categories: [NewsCategory]
    public let thumbnail: NewsThumbnail
}

public struct NewsListJSON: Codable {
    public let posts: [NewsListItem]
}
