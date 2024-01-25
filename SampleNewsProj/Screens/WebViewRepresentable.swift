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
    @Binding var contentHeight: CGFloat

    func makeUIView(context: UIViewRepresentableContext<WebViewRepresentable>) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ wkWebView: WKWebView, context: UIViewRepresentableContext<WebViewRepresentable>) {
        if let html = self.htmlString {
            wkWebView.loadHTMLString(html, baseURL: nil)
        } else if let url = self.url {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(contentHeight: $contentHeight)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var contentHeight: CGFloat
        var resized = false

        init(contentHeight: Binding<CGFloat>) {
            self._contentHeight = contentHeight
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.readyState") { complete, _ in
                guard complete != nil else { return }
                webView.evaluateJavaScript("document.body.scrollHeight") { height, _ in
                    guard let height = height as? CGFloat else { return }

                    if !self.resized {
                        self.contentHeight = height
                        self.resized = true
                    }
                }
            }
        }
    }
}
