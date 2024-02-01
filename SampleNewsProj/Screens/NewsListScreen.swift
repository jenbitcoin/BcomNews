//
//  NewsListScreen.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 1/24/24.
//

import Foundation
import SwiftUI

struct NewsListScreen<Model>: View where Model: NewsListViewModelProtocol {
    @StateObject var viewModel: Model

    var body: some View {
        let _ = Self._printChanges()
        
        NavigationStack {
            VStack {
                Text("Latest News")
                    .foregroundStyle(.black)
                    .font(.system(size: 18, weight: .bold))
                
                List {
                    ForEach(viewModel.posts) { post in
                        Button(action: post.onSelect) {
                            VStack(spacing: 8) {
                                HStack {
                                    AsyncImage(url: URL(string: post.imageURLString)) { image in
                                        image.image?
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                     }
                                    
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text(post.title)
                                                .foregroundStyle(.black)
                                                .multilineTextAlignment(.leading)
                                                .font(.system(size: 14, weight: .bold))
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text(post.date)
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 12, weight: .semibold))
                                            Spacer()
                                        }
                                        
                                    }
                                }
                                
                                Text(post.excerpt)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
                
                if let banner = viewModel.banner {
                    banner
                }
            }
            .navigationDestination(isPresented: $viewModel.showNews) {
                NewsDetailScreen(viewModel: NewsDetailViewModel(newsItem: viewModel.selectedPost!,
                                                                otherNews: viewModel.rawPosts,
                                                                apiClient: NewsAPIClient.shared))
            }            
        }
        .onAppear {
            viewModel.fetchLatestNews()
            viewModel.setupAdsViewController(UIHostingController(rootView: self))
        }
        
    }
}
