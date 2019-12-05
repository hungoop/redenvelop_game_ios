//
//  TitleStackView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/25/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit

class TitleStackView: UIView {
    enum CFG {
        static let marginTopBotton:CGFloat = 0
        static let marginLeftRight:CGFloat = 10
    }
    
    private lazy var prefixLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView().forAutolayout()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private var prefix: String
    private var title: String
    
    init(prefix: String, title: String) {
        self.prefix = prefix
        self.title = title
        super.init(frame: .zero)
        setupViews()
        prefixLabel.text = prefix
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        stackView.boundInside(view: self)
        
        if #available(iOS 11.0, *) {
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: CFG.marginTopBotton,
                                                                         leading: CFG.marginLeftRight,
                                                                         bottom: CFG.marginTopBotton,
                                                                         trailing: CFG.marginLeftRight)
        } else {
            stackView.layoutMargins = UIEdgeInsets(top: CFG.marginTopBotton,
                                                   left: CFG.marginLeftRight,
                                                   bottom: CFG.marginTopBotton,
                                                   right: CFG.marginLeftRight);
        }
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        stackView.addArrangedSubview(prefixLabel)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            //prefixLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            //prefixLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            prefixLabel.widthAnchor.constraint(equalToConstant: 70),
            
            //titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            //titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            ])
        
        let img:UIImage = UIImage(named: "bg_title_lobby")!
        self.layer.contents = img.cgImage
    }
}
