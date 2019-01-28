//
//  PDFViewController.swift
//  SaveData
//
//  Created by Yan Naing Tun on 1/22/19.
//  Copyright © 2019 Yan Naing Tun. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
    
            for url in fileURLs{
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
                webView.allowsBackForwardNavigationGestures = true
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
}
