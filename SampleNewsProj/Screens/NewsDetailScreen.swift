//
//  NewsDetailScreen.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 1/22/24.
//

import Foundation
import SwiftUI

struct WebScreen: View {
    var htmlString: String
    var body: some View {
        WebViewRepresentable(url: nil,
                             htmlString: htmlString)
    }
}

struct NewsDetailScreen<Model>: View where Model: NewsDetailViewModelProtocol {
    @StateObject var viewModel: Model

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .screen:
                if let news = viewModel.news {
                    WebScreen(htmlString: news.content)
                        .navigationTitle(news.title)
                        .navigationBarTitleDisplayMode(.inline)
                }
            case .error:
                Text("Something went wrong")
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.fetchNewsDetail()
        }
       
    }
}
