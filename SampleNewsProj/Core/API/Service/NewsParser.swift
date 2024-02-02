//
//  NewsParser.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 01/22/24.
//

import Foundation

public struct NewsJSON: Codable {
    public let title: String
    public let content: String
    public let meta_title: String
    public let meta_description: String
    public let barker_title: String
    public let late_barker_title: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let rawContent = try container.decode(String.self, forKey: .content)
        
        self.content = rawContent.removingSubranges(startChar: "[", endChar: "]")
        self.meta_title = try container.decode(String.self, forKey: .meta_title)
        self.meta_description = try container.decode(String.self, forKey: .meta_description)
        
        if let barkerTitle = try? container.decode(String.self, forKey: .barker_title) {
            self.barker_title = barkerTitle
        } else {
            self.barker_title = ""
        }
        
        if let lateBarkerTitle = try? container.decode(String.self, forKey: .late_barker_title) {
            self.late_barker_title = lateBarkerTitle
        } else {
            self.late_barker_title = ""
        }
        
    }
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
