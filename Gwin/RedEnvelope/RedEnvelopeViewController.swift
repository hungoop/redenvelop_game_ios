//
//  RedEnvelopeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/23/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit

class RedEnvelopeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rollMsgView: UIView!
    private lazy var marqueView:ScrollLabel = {
        let view = ScrollLabel().forAutolayout()
        return view
    }()
    
    var rooms: [RoomModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.tabBarController?.tabBar.isHidden = false
        
        setTitle(title: "扫雷")
        setupViews()
        fetchRoomList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackButton()
        processing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViews() {
        tableView.register(GameItemCell.self, forCellReuseIdentifier: "envelopRoomCell")
        
        rollMsgView.addSubview(marqueView)
        marqueView.updateContent(message: RedEnvelopComponent.shared.rollMsg)
        NSLayoutConstraint.activate([
            marqueView.leftAnchor.constraint(equalTo: rollMsgView.leftAnchor, constant: 40),
            marqueView.topAnchor.constraint(equalTo: rollMsgView.topAnchor),
            marqueView.rightAnchor.constraint(equalTo: rollMsgView.rightAnchor),
            marqueView.bottomAnchor.constraint(equalTo: rollMsgView.bottomAnchor),
            marqueView.heightAnchor.constraint(equalTo: rollMsgView.heightAnchor)
            ])
    }
    
    func fetchRoomList() {
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        
        RedEnvelopAPIClient.getRoomList(ticket: user.ticket, roomtype: RoomType.boom) {[weak self] (rooms, msg) in
            guard let this = self else { return }
            if let _rooms = rooms {
                this.rooms = _rooms
            }
            
            this.tableView.reloadData()
        }
    }
    
}

extension RedEnvelopeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func jumpURL(optType: String, title: String? = nil) {
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        showLoadingView()
        UserAPIClient.otherH5(ticket: user.ticket, optype: optType) {[weak self] (url, message) in
            guard let `this` = self else { return }
            this.hideLoadingView()
            if let jumpurl = url {
                let webview = WebContainerController(url: jumpurl, title: title)
                this.present(webview, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(UIDevice.current.iPad){
            return 220
        } else {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "envelopRoomCell", for: indexPath) as? GameItemCell {
            let model = rooms[indexPath.row]
            cell.selectionStyle = .none
            cell.updateView(model: model)
            cell.setImageBackground(imgName: "room_bg_boom")
            cell.setImagePlayGame(imgName: "room_play_game_bomb")
            cell.openRuleGame = {
                self.jumpURL(optType: "rule_1", title: "扫雷规则")
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model  = rooms[indexPath.row]
        
        if model.roomPwd.count > 0 {
            showInputPassword(room: model)
        } else {
            doLogin(room: model)
        }
    }
    
    func doLogin(room: RoomModel) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        guard let userno = RedEnvelopComponent.shared.userno else { return }
        if processing == true {
            return
        }
        
        processing = true
        showLoadingView()
        
        RedEnvelopAPIClient.roomLogin(ticket: user.ticket, roomId: room.roomId, roomPwd: room.roomPwd) { [weak self](success, message) in
            self?.hideLoadingView()
            self?.processing = false
            if success {
                let vc = RoomDetailViewController(userno: userno , room: room)
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                if let errorMsg = message {
                    self?.showAlertMessage(message: errorMsg)
                }
            }
        }
    }
}

extension RedEnvelopeViewController {
    fileprivate func showInputPassword(room: RoomModel) {
        let alertVC = UIAlertController(title: nil, message: "请输入房间密码", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "请输入房间密码"
            textField.textAlignment = .center
        })
        
        let saveAction = UIAlertAction(title: "确认", style: .default, handler: { [weak self] alert -> Void in
            if let firstTextField = alertVC.textFields?[0], let roompwd = firstTextField.text, roompwd == room.roomPwd {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self?.doLogin(room: room)
                })
            }else {
                self?.showAlertMessage(message: "输入密码错误，请重新输入")
            }
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        //    setupAnimationForAlert()
        //    DispatchQueue.main.async {  //make sure all UI updates are on the main thread.
        //      self.view.layer.add(CATransition().segueFromBottom(), forKey: nil)
        presentAlert(alertVC, animated: true, completion: nil)
        //    }
    }
}


