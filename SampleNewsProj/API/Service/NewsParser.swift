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
}

public struct NewsListItem: Codable {
    public let id: Int
    public let date: String
    public let title: String
    public let slug: String
    public let excerpt: String
}

public struct NewsListJSON: Codable {
    public let posts: [NewsListItem]
}
