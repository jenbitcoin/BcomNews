//
//  SampleNewsProjApp.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/24/24.
//

import SwiftUI

@main
struct SampleNewsProjApp: App {
    private let viewModel = NewsListViewModel(newsAPIClient: NewsAPIClient.shared,
                                              adsManager: AdsManager())
    
    init() {
        setupSDK()
        AdsManager.initializeGoogleAds()
    }
    
    var body: some Scene {
        WindowGroup {
            NewsListScreen(viewModel: self.viewModel)
        }
    }
    
    private func setupSDK() {
        SDKConfiguration.shared.api = SDKAPIData(rootScheme: AppConfig.apiRootScheme,
                                                 rootHost: AppConfig.apiRootHost,
                                                 serverHost: AppConfig.apiServerHost)
    }
}
