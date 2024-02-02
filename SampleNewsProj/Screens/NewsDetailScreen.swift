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
                                .navigationTitle(news.title)
                                .navigationBarTitleDisplayMode(.inline)
                            
                            authorInfoView
                                .background(Color(red: 0.91, green: 0.92, blue: 0.92))
                        }
                        .padding(.horizontal, 16)

                        //relatedStoriesView
                        
                        previousOrNextStoriesView
                        
                        Spacer()
                            .frame(height: 100)
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

                    Text(author.name)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, weight: .bold))
                    
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
    
    private var relatedStoriesView: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Related Stories")
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                }
                
                ForEach(viewModel.relatedNews) { post in
                    Button(action: post.onSelect) {
                        VStack(spacing: 8) {
                            HStack {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text(post.title)
                                            .foregroundStyle(.black)
                                            .multilineTextAlignment(.leading)
                                            .font(.system(size: 16, weight: .bold))
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text(post.date)
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 12, weight: .medium))
                                        Spacer()
                                    }
                                    
                                }
                                
                                AsyncImage(url: URL(string: post.imageURLString)) { image in
                                    image.image?
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                 }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                }
            }
            .padding(.horizontal, 16)
        }

    }
    
    private var previousOrNextStoriesView: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Don’t stop your journey in crypto")
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                }
                
                HStack(spacing: 16) {
                    ForEach(0..<2) { i in
                        let post = viewModel.relatedNews[i]
                        
                        ZStack {
                            Button(action: post.onSelect) {
                                VStack(spacing: 8) {
                                    Group {
                                        if i == 0 {
                                            HStack(spacing: 8) {
                                                Image(systemName: "arrow.left")
                                                    .tint(Color.black)
                                                
                                                Text("Previous story")
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: 14, weight: .bold))
                                                
                                                 Spacer()
                                            }
                                        } else {
                                            HStack(spacing: 8) {
                                                Spacer()
                                                
                                                Text("Next story")
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: 14, weight: .bold))
                                                
                                                Image(systemName: "arrow.right")
                                                    .tint(Color.black)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    
                                    AsyncImage(url: URL(string: post.imageURLString)) { image in
                                        image.image?
                                            .resizable()
                                            .frame(height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                     }
                                    
                                    Text(post.title)
                                        .foregroundStyle(.black)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    HStack {
                                        Text(post.date)
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 12, weight: .medium))
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
        }

    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
            case .screen:
                mainNewsView
                    .background(Color(red: 0.96, green: 0.96, blue: 0.97))
            case .error:
                Text("Something went wrong")
            }
            
            
            if let banner = viewModel.banner {
                VStack(spacing: 8) {
                    Spacer()
                    
                    floatingButtonsView

                    banner
                        .frame(height: 80)
                }
                .edgesIgnoringSafeArea(.bottom)
            } else {
                floatingButtonsView
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            viewModel.fetchNewsDetail()
            viewModel.setupAdsViewController(UIHostingController(rootView: self))
        }
    }
}
