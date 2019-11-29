//
//  GameItemCell.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class GameItemCell: UITableViewCell {
    
    var openRuleGame : ()->Void = {}
    
    
    enum Constants{
        static let signalSizeIphone: CGFloat = 30
        static let signalSizeIpad: CGFloat = 70
        
        static let defaultMargin: CGFloat = 8
    }
    
    private lazy var roomImageView: UIImageView = {
        let imageView = UIImageView().forAutolayout()
        imageView.image = UIImage(named: "room_bg_boom")
        return imageView
    }()
    
    private lazy var playGameImageView: UIImageView = {
        let imageView = UIImageView().forAutolayout()
        imageView.image = UIImage(named: "room_play_game_bomb")
        return imageView
    }()
    
    private lazy var stakeLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private lazy var signalView: UIView = {
        let view = UIView().forAutolayout()
        //view.rounded(radius: Constants.signalSize / 2)
        //view.backgroundColor = .red
        view.alpha = 0.05
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupViews() {
        contentView.addSubview(roomImageView)
        contentView.addSubview(stakeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(signalView)
        contentView.addSubview(playGameImageView)
        
        setupOpenRule()
        
        var btnRuleWith:CGFloat = 0;
        var topAnchor:CGFloat = 0;
        if(UIDevice.current.iPad){
            btnRuleWith = Constants.signalSizeIpad
            topAnchor = 20
        } else {
            btnRuleWith = Constants.signalSizeIphone
            topAnchor = 2
        }
        
        
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.defaultMargin),
            roomImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.defaultMargin),
            roomImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.defaultMargin),
            roomImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.defaultMargin),
            
            //roomImageView.widthAnchor.constraint(equalTo: roomImageView.heightAnchor),
            //roomImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //signalView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            signalView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            signalView.widthAnchor.constraint(equalToConstant: btnRuleWith),
            
            signalView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.defaultMargin),
            signalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.defaultMargin),
            
            
            stakeLabel.topAnchor.constraint(equalTo: roomImageView.topAnchor, constant: topAnchor),
            stakeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stakeLabel.rightAnchor.constraint(equalTo: signalView.leftAnchor, constant: -10),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: stakeLabel.bottomAnchor, constant: topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: signalView.leftAnchor, constant: -10),
            
            subTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topAnchor),
            subTitleLabel.rightAnchor.constraint(equalTo: signalView.leftAnchor, constant: -10),
            
            playGameImageView.bottomAnchor.constraint(equalTo: roomImageView.bottomAnchor, constant: -topAnchor),
            playGameImageView.rightAnchor.constraint(equalTo: signalView.leftAnchor, constant: -10),
            playGameImageView.widthAnchor.constraint(equalTo: signalView.heightAnchor, multiplier : 0.8),
            playGameImageView.heightAnchor.constraint(equalTo: playGameImageView.widthAnchor, multiplier: 0.2)
            
            
            ])
    }
    
    func updateView(model: RoomModel){
        stakeLabel.text = "\(model.stake1) - \(model.stake2)元"
        titleLabel.text = model.roomName
        subTitleLabel.text = model.roomDesc
    }
    
    func setImageBackground(imgName:String) {
        roomImageView.image = UIImage(named: imgName)
    }
    
    func setImagePlayGame(imgName:String) {
        playGameImageView.image = UIImage(named: imgName)
    }
    
    func setupOpenRule() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.signalViewTapped(_:)))
        signalView.isUserInteractionEnabled = true
        signalView.addGestureRecognizer(labelTap)
    }
    
    @objc func signalViewTapped(_ sender: UITapGestureRecognizer) {
        print("open rule game on room icon")
        openRuleGame()
    }
    
    
    
}

