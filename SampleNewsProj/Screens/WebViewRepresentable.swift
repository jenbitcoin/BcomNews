//
//  WebViewRepresentable.swift
//  SampleNews
//
//  Created by Jennifer Eve Curativo on 1/24/24.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let url: URL?
    let htmlString: String?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let html = self.htmlString {
            webView.loadHTMLString(html, baseURL: nil)
        } else if let url = self.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
