//
//  MenuHorizItemView.swift
//  Gwin
//
//  Created by Macintosh HD on 12/2/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MenuHorizItemView: UIView {
    
    private lazy var holderView: UIView = {
        let view = UIView().forAutolayout()
        //view.axis = NSLayoutConstraint.Axis.horizontal
        //view.distribution = UIStackView.Distribution.fill
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var separateView: UIView = {
        let view = UIView().forAutolayout()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    private lazy var textStackView: UIView = {
        let view = UIView().forAutolayout()
        return view
    }()
    
    private lazy var coverButton: UIButton = {
        let view = UIButton().forAutolayout()
        view.isUserInteractionEnabled = true
        view.addTarget(self, action: #selector(horizMenuItemPressed(_:)), for: .touchUpInside)
        return view
    }()
    
    private var imageView:UIImageView = {
        let view = UIImageView().forAutolayout()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel().forAutolayout()
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return view
    }()
    
    var menuItemHanler: (_ optType:String, _ title:String)->Void = {_,_ in }
    private let model: ProfileItemModel!
    
    init(model: ProfileItemModel) {
        self.model = model
        super.init(frame: .zero)
        
        setupViews()
        updateView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(holderView)
        addSubview(coverButton)
        
        NSLayoutConstraint.activate([
            holderView.topAnchor.constraint(equalTo: topAnchor),
            holderView.leftAnchor.constraint(equalTo: leftAnchor),
            holderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            holderView.rightAnchor.constraint(equalTo: rightAnchor),
            
            coverButton.topAnchor.constraint(equalTo: topAnchor),
            coverButton.leftAnchor.constraint(equalTo: leftAnchor),
            coverButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverButton.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        
        holderView.addSubview(imageView)
        holderView.addSubview(titleLabel)
        holderView.addSubview(separateView)
        
        imageView.contentMode = UIView.ContentMode.scaleToFill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: holderView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: holderView.heightAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: holderView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: holderView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: holderView.bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: holderView.rightAnchor),
            
            imageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10),
            
            separateView.rightAnchor.constraint(equalTo: holderView.rightAnchor),
            separateView.centerYAnchor.constraint(equalTo: holderView.centerYAnchor),
            separateView.heightAnchor.constraint(equalTo: holderView.heightAnchor, constant: -10),
            separateView.widthAnchor.constraint(equalToConstant: CGFloat(1)),
            ])
        
    }
    
    func updateView() {
        imageView.image = UIImage(named: model.icon)
        titleLabel.text = model.title
    }
    
    @objc func horizMenuItemPressed(_ sender: UIButton) {
        menuItemHanler(model.key, model.webTitle!)
    }
    
}
