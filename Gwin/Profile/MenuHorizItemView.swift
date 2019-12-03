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
    
    private lazy var stackView: UIView = {
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
        //view.contentMode = UIView.ContentMode.scaleToFill //.scaleAspectFit
        
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    private var titleLabel: UILabel = {
        let view = UILabel().forAutolayout()
        //view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 12 : 14)
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
        addSubview(stackView)
        addSubview(coverButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            
            coverButton.topAnchor.constraint(equalTo: topAnchor),
            coverButton.leftAnchor.constraint(equalTo: leftAnchor),
            coverButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            coverButton.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        
        stackView.addSubview(imageView)
        stackView.addSubview(titleLabel)
        stackView.addSubview(separateView)
        
        //stackView.addArrangedSubview(imageView)
        //stackView.addArrangedSubview(titleLabel)
        
        //let itemHeight = 40
        
        imageView.contentMode = UIView.ContentMode.scaleToFill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            //imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10),
            
            imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            //imageView.heightAnchor.constraint(equalToConstant: CGFloat(itemHeight)),
            //imageView.widthAnchor.constraint(equalToConstant: CGFloat(itemHeight)),
            imageView.widthAnchor.constraint(equalTo: stackView.heightAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: stackView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            
            imageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10),
            
            separateView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            separateView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            separateView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -10),
            separateView.widthAnchor.constraint(equalToConstant: CGFloat(1)),
            ])
        
    }
    
    func updateView() {
        imageView.image = UIImage(named: model.icon)
        titleLabel.text = model.title
    }
    
    @objc func horizMenuItemPressed(_ sender: UIButton) {
        // clouse dispacher
        print("------\(model.key)-------")
        
        menuItemHanler(model.key, model.webTitle!)
    }
    
}
