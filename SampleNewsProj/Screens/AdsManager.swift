//
//  AdsManager.swift
//  SampleNewsProj
//
//  Created by Jennifer Eve Curativo on 1/31/24.
//

import Foundation
import GoogleMobileAds
import SwiftUI

protocol AdsDelegate: AnyObject {
    func addAdsToView(with banner: AdBannerRepresentable)
}

final class AdsManager: NSObject {
    private var bannerView: GADBannerView!
    private var rootViewController: UIViewController
    private weak var showAdsDelegate: AdsDelegate?
        
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    static func initializeGoogleAds() {
        GADMobileAds.sharedInstance().start { status in
            debugPrint("setupGoogleAds completion status: ", status)
        }
    }

    func showAdBanner(showAdsDelegate: AdsDelegate) {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-4413360973090930/2566205549"
        bannerView.rootViewController = self.rootViewController
        bannerView.delegate = self
        self.showAdsDelegate = showAdsDelegate
        bannerView.load(GADRequest())
    }
}

extension AdsManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        showAdsDelegate?.addAdsToView(with: AdBannerRepresentable(bannerView: bannerView))
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

struct AdBannerRepresentable: UIViewRepresentable {
    var bannerView: GADBannerView
    func makeUIView(context: UIViewRepresentableContext<AdBannerRepresentable>) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bannerView)
        view.addConstraints(
              [NSLayoutConstraint(item: bannerView,
                                  attribute: .top,
                                  relatedBy: .equal,
                                  toItem: view.safeAreaLayoutGuide,
                                  attribute: .top,
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

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AdBannerRepresentable>) {
        uiView.frame = CGRect(x: 0,
                              y: UIScreen.main.bounds.height-50,
                              width: UIScreen.main.bounds.width,
                              height: 50)
    }
}
