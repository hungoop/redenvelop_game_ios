//
//  WebContainerController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit

class WebContainerController: BaseViewController {
    
    private lazy var webView: WKWebView = {
        let web = WKWebView().forAutolayout()
        web.navigationDelegate = self
        return web
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView().forAutolayout()
        view.backgroundColor = UIColor(hexString:"e75f48")
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton().forAutolayout()
        button.setImage(UIImage(named: "back_button"), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = AppColors.titleColor
        return label
    }()
    
    private var urlPath: String
    private var lastIndex: Int? = nil
    private var viewTitle: String?
    init(url: String, lastIndex: Int? = nil, title: String? = nil) {
        self.urlPath = url
        self.lastIndex = lastIndex
        self.viewTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "e75f48")
        setupHeaderView()
        setupWebview()
        showLoadingView()
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: guide.topAnchor),
                headerView.leftAnchor.constraint(equalTo: guide.leftAnchor),
                headerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 44),
                ])
            
        } else {
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.topAnchor),
                headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 44),
                ])
        }
        
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        titleLabel.text = viewTitle
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 5),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            ])
    }
    
    func setupWebview() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            ])
        
        if let url = URL(string: urlPath) {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        if let index = lastIndex {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.tabbarController?.selectItem(withIndex: index)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension WebContainerController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingView()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlURL = navigationAction.request.url!
        print(urlURL)
        print(navigationAction.navigationType)
        
        if urlURL.path.contains("paysend.aspx") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlURL)
            } else {
                UIApplication.shared.openURL(urlURL)
            }
            decisionHandler(.cancel)
            print("Redirected to browser. No need to open it locally cancel")
            
        } else{
            print("Open it locally")
            decisionHandler(.allow)
        }
    }
}

