//
//  SampleNewsProjApp.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/24/24.
//

import SwiftUI

@main
struct SampleNewsProjApp: App {
    private let viewModel = NewsListViewModel(newsAPIClient: NewsAPIClient.shared)
    
    var body: some Scene {
        WindowGroup {
            NewsListScreen(viewModel: self.viewModel)
        }
    }
}
