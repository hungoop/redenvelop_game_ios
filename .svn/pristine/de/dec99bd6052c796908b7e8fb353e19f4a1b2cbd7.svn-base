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
    
    private lazy var prefixLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg(), weight: .medium)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
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
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: CONST_GUI.marginBottomTitleLobby(),
                                                                         leading: CONST_GUI.marginLeftRightTitleLobby(),
                                                                         bottom: CONST_GUI.marginBottomTitleLobby(),
                                                                         trailing: CONST_GUI.marginLeftRightTitleLobby())
        } else {
            stackView.layoutMargins = UIEdgeInsets(top: CONST_GUI.marginBottomTitleLobby(),
                                                   left: CONST_GUI.marginLeftRightTitleLobby(),
                                                   bottom: CONST_GUI.marginBottomTitleLobby(),
                                                   right: CONST_GUI.marginLeftRightTitleLobby());
        }
        stackView.isLayoutMarginsRelativeArrangement = true
        
        
        stackView.addArrangedSubview(prefixLabel)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            prefixLabel.widthAnchor.constraint(equalToConstant: 150),
            ])
        
        let img:UIImage = UIImage(named: "bg_title_lobby")!
        self.layer.contents = img.cgImage
    }
}
