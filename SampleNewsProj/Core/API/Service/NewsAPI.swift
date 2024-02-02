//
//  NewsAPI.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 01/22/24.
//

import Foundation

public protocol NewsAPIClientProtocol {
    func getLatestPosts(perPage: Int, completion: @escaping (APIResponse<(NewsListJSON)>) -> Void)
    func getPostBy(slug: String, completion: @escaping (APIResponse<(NewsJSON)>) -> Void)
}

public class NewsAPIClient: APIClient, NewsAPIClientProtocol {
    
    public static let shared = NewsAPIClient()
    
    private override init() {}

    public func getLatestPosts(perPage: Int, completion: @escaping (APIResponse<(NewsListJSON)>) -> Void) {
        let urlString = "posts"
        
        let queryItems = [
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        let url = APIClient.apiUrlFromPath(format: urlString, queryItems)
        self.request(url: url, completion: completion, parse: self.parseNewsListJSON)
    }
    
    public func getPostBy(slug: String, completion: @escaping (APIResponse<(NewsJSON)>) -> Void) {
        let urlString = "extra"
        
        let queryItems = [
            URLQueryItem(name: "p", value: slug)
        ]
        let url = APIClient.apiUrlFromPath(format: urlString, queryItems)
        self.request(url: url, completion: completion, parse: self.parseNewsJSON)
    }
    
    private func parseNewsJSON(_ data: Data) -> APIResponse<NewsJSON> {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsJSON.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.UnexpectedResponse)
        }
    }

    private func parseNewsListJSON(_ data: Data) -> APIResponse<NewsListJSON> {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsListJSON.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.UnexpectedResponse)
        }
    }
}
