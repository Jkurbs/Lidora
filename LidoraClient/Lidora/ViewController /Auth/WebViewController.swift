//
//  WebViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 10/1/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let myURL = URL(string:"https://lidoralive.wordpress.com/2020/09/24/terms-of-use/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func dismiss() {
        
    }
}
