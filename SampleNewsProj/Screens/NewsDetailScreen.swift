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
                    VStack {
                        Text(news.title)
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20, weight: .bold))
                        
                        AsyncImage(url: URL(string: news.thumbnailURLString)) { image in
                            image.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                         }
                        
                        WebScreen(htmlString: news.content)
                            .navigationTitle(news.title)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            case .error:
                Text("Something went wrong")
            }
        }
        .onAppear {
            viewModel.fetchNewsDetail()
        }
        .navigationTitle("News")
    }
}
