//
//  WebView.swift
//  reddit-place
//
//  Created by chuy g on 22/04/22.
//

import SwiftUI
import WebKit

// MARK: - WebViewHandlerDelegate
protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
    func receivedStringValueFromWebView(value: String)
}


struct WebView: UIViewRepresentable, WebViewHandlerDelegate {
    
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("JSON value received from web is: \(value)")
    }
    
    func receivedStringValueFromWebView(value: String) {
        print("String value received from web is: \(value)")
    }
    
    
    // MARK: - Properties
    
    var webView: WKWebView?
    
    init(web: WKWebView? = nil) {
        self.webView = WKWebView()
    }
    
    // Make a coordinator to co-ordinate with WKWebView's default delegate functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Enable javascript in WKWebView
//        let preferences = WKPreferences()
        webView!.navigationDelegate = context.coordinator
        webView!.allowsBackForwardNavigationGestures = true
        webView!.scrollView.isScrollEnabled = true
        return webView!
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Adding webView content
        do {
            guard let filePath = Bundle.main.path(forResource: "src", ofType: "html")
            else {
                // File Error
                print ("File reading error")
                return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            fatalError("File HTML error")
        }
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        var delegate: WebViewHandlerDelegate?
        
        init(_ uiWebView: WebView) {            
            self.parent = uiWebView
            self.delegate = parent
        }
        
        deinit {
            //...
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        }
        
        // This function is essential for intercepting every navigation in the webview
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let host = navigationAction.request.url?.host {
                if host == "restricted.com" {
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
