//
//  AdsManager.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/31/24.
//

import Foundation
import GoogleMobileAds

final class AdsManager: NSObject {
    private var adLoader: GADAdLoader?
    var rootViewController: UIViewController
        
    init(adLoader: GADAdLoader? = nil, rootViewController: UIViewController) {
        self.adLoader = adLoader
        self.rootViewController = rootViewController
    }

    static func initializeGoogleAds() {
        GADMobileAds.sharedInstance().start { status in
            debugPrint("setupGoogleAds completion status: ", status)
        }
    }
    
    func loadAds() {
        adLoader?.load(GADRequest())
    }
    
    func initializeAdLoader() {
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdOptions.numberOfAds = 5;
        
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511",
                               rootViewController: self.rootViewController,
                               adTypes: [.native],
                               options: [multipleAdOptions])
        adLoader?.delegate = self
    }
}

extension AdsManager: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        debugPrint("Did fail to receive ad")
    }
    
    public func adLoader(_ adLoader: GADAdLoader,
                         didReceive nativeAd: GADNativeAd) {
        debugPrint("did receive ad successfully")
    }
}
