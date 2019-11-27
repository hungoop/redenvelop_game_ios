//
//  ProfileItemViewCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ProfileItemAction: String {
    case web = "webview"
    case sound = "sound"
    case qrcode = "qrcode"
    case version = "version"
    case logout = "logout"
}

struct ProfileItemModel {
    var icon: String
    var title: String
    var webTitle: String?
    var key: String
    var action: String
    init(json: JSON) {
        icon = json["icon"].stringValue
        title = json["title"].stringValue
        key = json["key"].stringValue
        action = json["action"].stringValue
        webTitle = json["webTitle"].string
    }
}

class ProfileItemViewCell: UITableViewCell {
    enum Constants {
        static let defaultMargin: CGFloat = 4
        static let buttonRightMargin: CGFloat = 5
    }
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView().forAutolayout()
        view.contentMode = .scaleAspectFit
        view.image =  UIImage(named: "profile_item_1")
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel().forAutolayout()
        view.text = "abc"
        view.font = UIDevice.current.iPad ?  UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton().forAutolayout()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "profile_item_arrow"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton().forAutolayout()
        button.rounded(radius: 4)
        button.addBorder(color:UIColor(hexString: "e75f48"), width: 1)
        button.setTitle("复制", for: .normal)
        button.setTitleColor(UIColor(hexString: "e75f48"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(copyPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var qrcodeLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hexString: "e75f48")
        label.text = "QRCODE"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var versionButton: UIButton = {
        let button = UIButton().forAutolayout()
        button.rounded(radius: 4)
        button.addBorder(color:UIColor(hexString: "e75f48"), width: 1)
        button.setTitle("新版本", for: .normal)
        button.setTitleColor(UIColor(hexString: "e75f48"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(copyPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hexString: "e75f48")
        label.text = "VERSION"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private var model: ProfileItemModel?
    var didCopyQRCode: ()->Void = {}
    var didUpdateNewVersion: ()->Void = {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(actionButton)
        addSubview(copyButton)
        addSubview(qrcodeLabel)
        
        addSubview(versionButton)
        addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.defaultMargin),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultMargin),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            
            actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.buttonRightMargin),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 30),
            
            copyButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.buttonRightMargin),
            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 30),
            copyButton.widthAnchor.constraint(equalToConstant: 60),
            
            qrcodeLabel.rightAnchor.constraint(equalTo: copyButton.leftAnchor, constant: -Constants.buttonRightMargin),
            qrcodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            versionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.buttonRightMargin),
            versionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            versionButton.heightAnchor.constraint(equalToConstant: 30),
            versionButton.widthAnchor.constraint(equalToConstant: 60),
            
            versionLabel.rightAnchor.constraint(equalTo: versionButton.leftAnchor, constant: -Constants.buttonRightMargin),
            versionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    private func updateContrainVersion() {
        NSLayoutConstraint.activate([
            versionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.buttonRightMargin),
            versionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            versionLabel.heightAnchor.constraint(equalToConstant: 30),
            versionLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func updateContent(data: ProfileItemModel, qrcode: String? = nil, isUpdate: Bool? = false) {
        model = data
        iconImageView.image = UIImage(named: data.icon)
        titleLabel.text = data.title
        
        if data.action == ProfileItemAction.logout.rawValue {
            actionButton.isHidden = true
            
            versionLabel.isHidden = true
            versionButton.isHidden = true
            
            copyButton.isHidden = true
            qrcodeLabel.isHidden = true
        } else if data.key == ProfileItemAction.version.rawValue {
             //actionButton.setImage(nil, for: .normal)
             //let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
             //actionButton.setTitle(appVersion, for: .normal)
            
            if (isUpdate ?? false){
                versionButton.isHidden = false
                
            } else {
                versionButton.isHidden = true
                updateContrainVersion()
            }
            
            versionLabel.isHidden = false
            
            actionButton.isHidden = true
            copyButton.isHidden = true
            qrcodeLabel.isHidden = true
            
            versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
         } else if data.key == ProfileItemAction.qrcode.rawValue {
            versionButton.isHidden = true
            versionLabel.isHidden = true
            actionButton.isHidden = true
            
            copyButton.isHidden = false
            qrcodeLabel.isHidden = false
            
            qrcodeLabel.text = qrcode
        } else if data.key == ProfileItemAction.sound.rawValue {
            actionButton.setImage(UIImage(named: "profile_sound_on"), for: .normal)
            actionButton.setImage(UIImage(named: "profile_sound_off"), for: .selected)
            let sound = UserDefaultManager.sharedInstance().settingSound()
            actionButton.isSelected = sound
            
            actionButton.isHidden = false
            versionLabel.isHidden = true
            versionButton.isHidden = true
            
            copyButton.isHidden = true
            qrcodeLabel.isHidden = true
        } else {
            actionButton.isHidden = false
            actionButton.setImage(UIImage(named: "profile_item_arrow"), for: .normal)
            actionButton.setImage(UIImage(named: "profile_item_arrow"), for: .selected)
            actionButton.setTitleColor(.black, for: .normal)
            
            versionLabel.isHidden = true
            versionButton.isHidden = true
            
            copyButton.isHidden = true
            qrcodeLabel.isHidden = true
        }
        /*
        let isQRCodeItem  = (data.key == ProfileItemAction.qrcode.rawValue)
        copyButton.isHidden = !isQRCodeItem
        qrcodeLabel.isHidden = !isQRCodeItem
        actionButton.isHidden = isQRCodeItem || data.action == ProfileItemAction.logout.rawValue
        qrcodeLabel.text = qrcode
        
        */
    }
    
    @objc func actionButtonPressed(_ sender: UIButton) {
        if let `model` = model, model.action == ProfileItemAction.sound.rawValue {
            actionButton.isSelected = !actionButton.isSelected
            let sound = actionButton.isSelected
            UserDefaultManager.sharedInstance().setSettingSound(on: sound)
        }
        
    }
    
    @objc func copyPressed(_ sender: UIButton) {
        if let `model` = model, model.action == ProfileItemAction.qrcode.rawValue {
            didCopyQRCode()
        } else if let `model` = model, model.action == ProfileItemAction.version.rawValue {
            didUpdateNewVersion()
        }
    }
    
    
}

