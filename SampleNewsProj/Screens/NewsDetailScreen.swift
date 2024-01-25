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
    @Binding var webViewHeight: CGFloat
    
    var body: some View {
        WebViewRepresentable(url: nil,
                             htmlString: htmlString,
                             contentHeight: $webViewHeight)
    }
}

struct NewsDetailScreen<Model>: View where Model: NewsDetailViewModelProtocol {
    @StateObject var viewModel: Model
    @State var webViewHeight: CGFloat = 0

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .screen:
                if let news = viewModel.news {
                    GeometryReader { reader in
                        ScrollView {
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
                                
                                WebScreen(htmlString: news.content, webViewHeight: $webViewHeight)
                                    .frame(width: reader.size.width, height: max(reader.size.height, self.webViewHeight))
                                    .edgesIgnoringSafeArea(.bottom)
                                    .navigationTitle(news.title)
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                        }
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
