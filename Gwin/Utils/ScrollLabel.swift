//
//  ScrollLabel.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/26/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit

class ScrollLabel: UIView {
    
    private lazy var webview: WKWebView = {
        let webview = WKWebView().forAutolayout()
        webview.backgroundColor = .white
        webview.scrollView.isScrollEnabled = false
        webview.scrollView.bounces = false
        return webview
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(webview)
        
        NSLayoutConstraint.activate([
            webview.leftAnchor.constraint(equalTo: leftAnchor),
            webview.rightAnchor.constraint(equalTo: rightAnchor),
            webview.topAnchor.constraint(equalTo: topAnchor),
            webview.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ])
    }
    
    func updateContent(message: String?) {
        let marquee = "<html><body><font size=\"\(CONST_GUI.fontSizeRollMessage())\" face=\"sans-serif\"> <marquee>\(message ?? "")</marquee></font></body></html>"
        webview.loadHTMLString(marquee, baseURL: nil)
    }
}

