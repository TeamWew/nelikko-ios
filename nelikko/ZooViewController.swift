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

    func webViewDidStartLoad(webView: UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
        frame.origin.y = UIApplication.sharedApplication().statusBarFrame.height
        frame.size.height -= frame.origin.y
        
        let webView = UIWebView(frame: frame)
        webView.delegate = self
        webView.scalesPageToFit = true
        view.addSubview(webView)
        
        let url = NSURL(string: "http://www.apple.com")
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
        view.addSubview(webView)
        
    }
    
    
}