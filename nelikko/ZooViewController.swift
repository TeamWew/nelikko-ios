//
//  ZooViewController.swift
//  nelikko
//
//  Created by Ilari Lind on 09.11.15.
//  Copyright © 2015 TeamWew. All rights reserved.
//

import UIKit
import Foundation

class ZooViewController: UIViewController, UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    /***
        4chan caches
        rbt.asia - http://rbt.asia/(board)/thread/(thread.no)
        eg.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Render the web view under the status bar */
        var frame = view.bounds
        frame.origin.y = UIApplication.shared.statusBarFrame.height
        frame.size.height -= frame.origin.y
        
        let webView = UIWebView(frame: frame)
        webView.delegate = self
        webView.scalesPageToFit = true
        view.addSubview(webView)
        
        let url = URL(string: "http://www.apple.com")
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)
        
        view.addSubview(webView)
        
    }
    
    
}
