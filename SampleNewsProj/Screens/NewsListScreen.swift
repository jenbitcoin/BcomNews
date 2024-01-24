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
                                Group {
                                    HStack {
                                        Text(post.title)
                                            .foregroundStyle(.black)
                                            .font(.system(size: 14, weight: .bold))
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text(post.date)
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 12, weight: .semibold))
                                        Spacer()
                                    }
                                    
                                    Text(post.excerpt)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showNews) {
                NewsDetailScreen(viewModel: NewsDetailViewModel(slug: viewModel.selectedPost!,
                                                                apiClient: NewsAPIClient.shared))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.fetchLatestNews()
        }
        
    }
}
