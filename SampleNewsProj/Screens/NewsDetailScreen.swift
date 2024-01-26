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
    
    private var floatingButtonsView: some View {
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .circular)
                    .fill(Color.black)
                    .frame(width: 96, height: 40)

                HStack(spacing: 16) {
                    Button {
                        debugPrint("Save Post!")
                    } label: {
                        Image(systemName: "bookmark")
                            .tint(Color.white)
                    }
                    
                    Button {
                        debugPrint("Share Post!")
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .tint(Color.white)
                    }
                }
            }
            .frame(width: 96, height: 40)
            
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var mainNewsView: some View {
        if let news = viewModel.news {
            GeometryReader { reader in
                ScrollView {
                    VStack(spacing: 24) {
                        AsyncImage(url: URL(string: news.thumbnailURLString)) { image in
                            image.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                         }
                        
                        Group {
                            Text(news.title)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 26, weight: .bold))

                            HStack {
                                AsyncImage(url: URL(string: news.author.avatarURLString)) { image in
                                    image.image?
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .aspectRatio(contentMode: .fill)
                                 }
                                
                                Text("By ")
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 14, weight: .regular))

                                Text(news.author.name)
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 14, weight: .regular))
                                
                                Spacer()
                            }
                            
                            WebScreen(htmlString: news.content, webViewHeight: $webViewHeight)
                                .frame(width: reader.size.width - 32, height: max(reader.size.height, self.webViewHeight))
                                .edgesIgnoringSafeArea(.bottom)
                                .navigationTitle(news.title)
                                .navigationBarTitleDisplayMode(.inline)
                            
                            authorInfoView
                                .background(Color.gray.opacity(0.3))

                        }
                        .padding(.horizontal, 16)

                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var authorInfoView: some View {
        if let author = viewModel.news?.author {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: author.avatarURLString)) { image in
                        image.image?
                            .resizable()
                            .frame(width: 64, height: 64)
                            .aspectRatio(contentMode: .fill)
                     }

                    VStack(spacing: 8) {
                        HStack {
                            Text(author.name)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 18, weight: .bold))
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 32, height: 32)
                            
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 32, height: 32)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                
                Text(author.info)
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("SF Pro Display", size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .screen:
                mainNewsView
            case .error:
                Text("Something went wrong")
            }
            
            floatingButtonsView
        }
        .onAppear {
            viewModel.fetchNewsDetail()
        }
        .navigationTitle("News")
    }
}
