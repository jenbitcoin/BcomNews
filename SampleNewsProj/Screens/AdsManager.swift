//
//  AdsManager.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/31/24.
//

import Foundation
import GoogleMobileAds

final class AdsManager: NSObject {
    private var bannerView: GADBannerView!
    private var rootViewController: UIViewController
        
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    static func initializeGoogleAds() {
        GADMobileAds.sharedInstance().start { status in
            debugPrint("setupGoogleAds completion status: ", status)
        }
    }

    func initializeAdBanner() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-4413360973090930/2566205549"
        bannerView.rootViewController = self.rootViewController
        bannerView.load(GADRequest())
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        guard let view = self.rootViewController.view else {
            return
        }
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bannerView)
        view.addConstraints(
              [NSLayoutConstraint(item: bannerView,
                                  attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: view.safeAreaLayoutGuide,
                                  attribute: .bottom,
                                  multiplier: 1,
                                  constant: 0),
               NSLayoutConstraint(item: bannerView,
                                  attribute: .centerX,
                                  relatedBy: .equal,
                                  toItem: view,
                                  attribute: .centerX,
                                  multiplier: 1,
                                  constant: 0)
              ])
    }
}

extension AdsManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        addBannerViewToView(bannerView)
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
