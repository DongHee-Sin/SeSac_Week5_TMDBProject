//
//  WebViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/05.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Outlet & Propertys
    var linkKey: String?
    
    @IBOutlet private weak var webView: WKWebView!
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    

    // MARK: - Methods
    func configureInitialUI() {
        openWebView(url: EndPoint.youtubeEndPoint + (linkKey ?? ""))
    }
    
    
    private func openWebView(url: String) {
        guard let url = URL(string: url) else {
            present404Alert()
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    private func present404Alert() {
        let alertController = UIAlertController(title: "404", message: "NOT FOUND", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction private func dismissButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction private func backButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    
    @IBAction private func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    
    @IBAction private func forwardButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
}
