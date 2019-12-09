//
//  LobbyItemView.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/21/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LobbyItemModel {
    var icon: String
    var name: String
    var key: String
    var action: String
    
    init(dictionary: JSON, isLot:Bool = false) {
        if(isLot){
            let ishot = dictionary["ishot"].boolValue
            let gameno = dictionary["gameno"].intValue
            
            key = "\(gameno)"
            name = dictionary["gamename"].stringValue
            action = "lottery"
            
            if(ishot){
                icon = "icon_lottery_hot"
            } else {
                icon = "icon_lottery_nomal"
            }
        } else{
            icon = dictionary["icon"].stringValue
            name = dictionary["name"].stringValue
            key = dictionary["key"].stringValue
            action = dictionary["action"].stringValue
        }
    }
}

protocol LobbyItemViewOuput: AnyObject {
    func pressedLobbyItem(model: LobbyItemModel)
}

class LobbyItemView: UIView {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView().forAutolayout()
        view.axis = self.axis
        view.distribution = .fill
        
        return view
    }()
    
    private lazy var textStackView: UIView = {
        let view = UIView().forAutolayout()
        return view
    }()
    
    private lazy var coverButton: UIButton = {
        let view = UIButton().forAutolayout()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(lobbyItemPressed(_:)), for: .touchUpInside)
        return view
    }()
    
    private var imageView:UIImageView = {
        let view = UIImageView().forAutolayout()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel().forAutolayout()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return view
    }()
    
    private var subtitleLAbel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return label
    }()
    
    private let model: LobbyItemModel!
    private var output: LobbyItemViewOuput
    private var axis: NSLayoutConstraint.Axis
    private var typeIcon: Int
    init(model: LobbyItemModel, axis: NSLayoutConstraint.Axis = .vertical, typeIcon: Int = 1, output: LobbyItemViewOuput) {
        self.model = model
        self.output = output
        self.axis = axis
        self.typeIcon = typeIcon
        super.init(frame: .zero)
        setupViews()
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        addSubview(coverButton)
        //let itemHeight = UIScreen.main.bounds.width / 7
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            coverButton.topAnchor.constraint(equalTo: topAnchor),
            coverButton.leftAnchor.constraint(equalTo: leftAnchor),
            coverButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverButton.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        
        stackView.addArrangedSubview(imageView)
        if axis == .vertical {
            stackView.addArrangedSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.widthAnchor.constraint(equalTo: coverButton.widthAnchor),
                titleLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1.0 / 3.0),
                titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
                
                imageView.widthAnchor.constraint(equalTo: coverButton.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 2.0 / 3.0),
                imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
                
                ])
           
        } else if axis == .horizontal {//icon lottery && icon play game
            imageView.contentMode = UIView.ContentMode.scaleToFill
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: coverButton.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: coverButton.heightAnchor),
                ])
            
        }
    }
    
    func updateView() {
        imageView.image = UIImage(named: model.icon)
        
        if(typeIcon == -1) {
            titleLabel.text = model.name
        }
        
        if(typeIcon == 2){
            coverButton.setTitle("\(model.name)", for: .normal)
            coverButton.setTitleColor(UIColor.darkGray, for: .normal)
            coverButton.titleLabel?.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeButtonLobby())
        }
    }
    
    @objc func lobbyItemPressed(_ sender: UIButton) {
        output.pressedLobbyItem(model: model)
    }
}

