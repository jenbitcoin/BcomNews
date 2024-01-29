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
        guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
            return WKWebView()
        }

        let cssString = try! String(contentsOfFile: path).components(separatedBy: .newlines).joined()
        let source = """
          var style = document.createElement('style');
          style.innerHTML = '\(cssString)';
          document.head.appendChild(style);
        """

        let userScript = WKUserScript(source: source,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ wkWebView: WKWebView, context: UIViewRepresentableContext<WebViewRepresentable>) {
        if let htmlString = self.htmlString {
            let html = """
            <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                </head>
                <body>
                    \(htmlString)
                </body>
            </html>
            """
            
            wkWebView.loadHTMLString(html, baseURL: nil)
        } else if let url = self.url {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
        
        wkWebView.configuration.userContentController.removeAllUserScripts()
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
