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
    
    @ViewBuilder
    var newsListView: some View {
        List {
            ForEach(viewModel.posts) { post in
                Button(action: post.onSelect) {
                    VStack(spacing: 8) {
                        HStack {
                            AsyncImage(url: URL(string: post.imageURLString)) { image in
                                image.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
                .task {
                    if viewModel.hasReachedEndOfList(newsDisplayId: post.id) {
                        viewModel.loadMoreNews()
                    }
                }
            }
        }
    }

    var body: some View {
        let _ = Self._printChanges()
        
        NavigationStack {
            VStack {
                Text("Latest News")
                    .foregroundStyle(.black)
                    .font(.system(size: 18, weight: .bold))
                
                newsListView
                
                if viewModel.posts.count > 0 && viewModel.state == .loading {
                    ProgressView()
                        .background(.clear)
                        .frame(width: 50, height: 50)
                }
                
                if let banner = viewModel.banner {
                    banner
                        .frame(height: 50)
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
