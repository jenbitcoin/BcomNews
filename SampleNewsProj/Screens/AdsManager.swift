//
//  AdsManager.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/31/24.
//

import Foundation
import GoogleMobileAds

protocol AdsDelegate: AnyObject {
    func showAds(with adsView: UIView)
}

final class AdsManager: NSObject {
    private var bannerView: GADBannerView!
    private weak var adsDelegate: AdsDelegate?

    static func initializeGoogleAds() {
        GADMobileAds.sharedInstance().start { status in
            debugPrint("setupGoogleAds completion status: ", status)
        }
    }

    func initializeAdBanner() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-4413360973090930/2566205549"
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
}

extension AdsManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        adsDelegate?.showAds(with: bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
