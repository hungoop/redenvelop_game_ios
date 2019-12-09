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
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel().forAutolayout()
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: CONST_GUI.fontSizeMemberCenter_avg())
        return label
    }()
    
    private lazy var playBtnView: UIView = {
        let view = UIView().forAutolayout()
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        contentView.addSubview(roomImageView)
        contentView.addSubview(stakeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(playBtnView)
        contentView.addSubview(playGameImageView)
        
        setupOpenRule()
        
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CONST_GUI.defaultMarginRoom()),
            roomImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: CONST_GUI.defaultMarginRoom()),
            roomImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -CONST_GUI.defaultMarginRoom()),
            roomImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CONST_GUI.defaultMarginRoom()),
            
            playBtnView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            playBtnView.widthAnchor.constraint(equalToConstant: CONST_GUI.widthButtonRuleRoom()),
            playBtnView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CONST_GUI.defaultMarginRoom()),
            playBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CONST_GUI.defaultMarginRoom()),
            
            stakeLabel.topAnchor.constraint(equalTo: roomImageView.topAnchor, constant: CONST_GUI.spaceElementRoom()),
            stakeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stakeLabel.rightAnchor.constraint(equalTo: playBtnView.leftAnchor, constant: -10),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: stakeLabel.bottomAnchor, constant: CONST_GUI.spaceElementRoom()),
            titleLabel.rightAnchor.constraint(equalTo: playBtnView.leftAnchor, constant: -10),
            
            subTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CONST_GUI.spaceElementRoom()),
            subTitleLabel.rightAnchor.constraint(equalTo: playBtnView.leftAnchor, constant: -10),
            
            playGameImageView.bottomAnchor.constraint(equalTo: roomImageView.bottomAnchor, constant: -CONST_GUI.spaceElementRoom()),
            playGameImageView.rightAnchor.constraint(equalTo: playBtnView.leftAnchor, constant: -10),
            playGameImageView.widthAnchor.constraint(equalTo: playBtnView.heightAnchor, multiplier : 0.8),
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
        playBtnView.isUserInteractionEnabled = true
        playBtnView.addGestureRecognizer(labelTap)
    }
    
    @objc func signalViewTapped(_ sender: UITapGestureRecognizer) {
        openRuleGame()
    }
    
    
    
}

