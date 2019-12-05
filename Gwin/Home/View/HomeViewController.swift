//
//  HomeViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MarqueeLabel

protocol HomeViewInput: AnyObject {
    func updatePopularizeImage(images: [String])
}

protocol HomeViewOutput: AnyObject {
    func viewDidLoad()
}

public protocol HomeViewControllerInput: AnyObject {
}

class HomeViewController: BaseViewController {
    
    enum CFG {
        static let seperateHeight: CGFloat = 2
        static let marginTopBotton:CGFloat = 5
        static let marginLeftRight:CGFloat = 5
        
        static let marginBottom_lot:CGFloat = 0
    }
    
    private func setMarginStackView(sView:UIView, top:CGFloat, left:CGFloat, bottom:CGFloat, right:CGFloat) {
        if #available(iOS 11.0, *) {
            sView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: top,
                                                                     leading: left,
                                                                     bottom: bottom,
                                                                     trailing: right)
        } else {
            sView.layoutMargins = UIEdgeInsets(top: top,
                                               left: left,
                                               bottom: bottom,
                                               right: right);
        }
        
        if (sView is UIStackView){
            (sView as! UIStackView).isLayoutMarginsRelativeArrangement = true
        }
        
    }
    
    weak var output: HomeViewOutput?
    
    private var carouselView: CarouselView!
    
    private var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var desScriptionLabel: UILabel = {
        var label = UILabel().forAutolayout()
        return label
    }()
    
    private var messageLabel: ScrollLabel = {
        var label = ScrollLabel().forAutolayout()
        return label
    }()
    
    private lazy var volumeImageView: UIImageView = {
        let image = UIImageView().forAutolayout()
        image.image = UIImage(named: "image_volume")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var volumSeperateView: UIView = {
        let view = UIView().forAutolayout()
        view.backgroundColor = .groupTableViewBackground
        return view
    }()
    
    //() -> UIStackView
    private func seperateLineView() -> UIView {
        let view = UIView().forAutolayout()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#f6f6f6")
        return view
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
    
    private var popupVc: MessagePopupController?
    
    private var lobbies: [LobbyItemModel] = []
    
    private var lstLottery: [LobbyItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: AppText.Titles.home)
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupViews()
        
        loadLobbyData()
        bindDataToView()
        
        fetchListGameLottery()
        
        fetchPopularizeImage()
        fetchRollMessage()
        fetchPopupMessage()
        fetchUserStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBackButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popupVc?.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        carouselView = CarouselView()
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(carouselView)
        view.addSubview(messageView)
        
        carouselView.layer.cornerRadius = 20
        carouselView.layer.masksToBounds = true
        view.backgroundColor = UIColor(hexString:"e75f48")
        
        NSLayoutConstraint.activate([
            carouselView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            carouselView.topAnchor.constraint(equalTo: view.topAnchor),
            carouselView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            carouselView.heightAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 3.0 / 7.0),
            
            messageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            
            messageView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 5),
            messageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            messageView.heightAnchor.constraint(equalToConstant: 25),
            ])
        
        messageView.addSubview(messageLabel)
        messageView.addSubview(volumeImageView)
        messageView.addSubview(volumSeperateView)
        messageView.addSubview(desScriptionLabel)
        
        desScriptionLabel.text = "公告"
        desScriptionLabel.font = desScriptionLabel.font.withSize(14)
        
        NSLayoutConstraint.activate([
            desScriptionLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 5),
            desScriptionLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            desScriptionLabel.widthAnchor.constraint(equalTo: messageView.heightAnchor, constant: 10),
            
            //
            volumeImageView.leftAnchor.constraint(equalTo: desScriptionLabel.rightAnchor),
            volumeImageView.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            volumeImageView.widthAnchor.constraint(equalTo: messageView.heightAnchor),
            //
            volumSeperateView.leftAnchor.constraint(equalTo: volumeImageView.rightAnchor),
            volumSeperateView.widthAnchor.constraint(equalToConstant: 1),
            volumSeperateView.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            
            //
            messageLabel.leftAnchor.constraint(equalTo: volumeImageView.rightAnchor, constant: 5),
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor),
            messageLabel.heightAnchor.constraint(equalTo: messageView.heightAnchor)
            ])
        //
        setupScrollView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 5),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
            ])
    }
    
    func loadLobbyData() {
        if let path = Bundle.main.path(forResource: "LobbyJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObj = try JSON(data: data).array
                
                jsonObj?.forEach{ json in
                    let lobby = LobbyItemModel(dictionary: json)
                    lobbies.append(lobby)
                }
            } catch {
                // handle error
                print("Abcdef")
            }
        }
    }
    
    func bindDataToView() {
        let stackView1 = getStackView()
        let firstSeperateView = seperateLineView()
        
        containerStackView.addArrangedSubview(stackView1)
        containerStackView.addArrangedSubview(firstSeperateView)
        let itemHeight = view.frame.width / (UIDevice.current.iPad ? 10 : 7)
        
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            stackView1.heightAnchor.constraint(equalToConstant: itemHeight)
            ])
        
        let buttonSize = view.frame.width / 6
        var lobbyIndex = 0
        
        if lobbies.count <= 0 {
            return
        }
        
        for _ in 0..<5 {
            let button = LobbyItemView(model: lobbies[lobbyIndex], axis: .vertical, typeIcon: -1, output: self)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView1.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: stackView1.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize)),
                button.heightAnchor.constraint(equalToConstant: itemHeight),
                ])
            
            lobbyIndex += 1
        }
        
        let stackView2 = getStackView()
        containerStackView.addArrangedSubview(stackView2)
        
        let btn_bb_itemHeight = view.frame.width / 3
        
        NSLayoutConstraint.activate([
            firstSeperateView.heightAnchor.constraint(equalToConstant: CFG.seperateHeight),
            firstSeperateView.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 0),
            
            stackView2.heightAnchor.constraint(equalToConstant: btn_bb_itemHeight),
            ])
        
        setMarginStackView(sView: stackView2, top: CFG.marginTopBotton, left: CFG.marginLeftRight, bottom: CFG.marginTopBotton, right: CFG.marginLeftRight)
        
        let item2Width = view.frame.width / 2 - CFG.marginLeftRight
        
        for _ in 0..<2 {
            let button = LobbyItemView(model: lobbies[lobbyIndex], axis: .horizontal, output: self)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView2.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: item2Width),
                ])
            
            lobbyIndex += 1
        }
        
        //
        let lastSeperateView = seperateLineView()
        let stackView_title_lot = getStackView()
        let lasttitleLabel = TitleStackView(prefix: "快乐彩票", title: "").forAutolayout()
        
        containerStackView.addArrangedSubview(lastSeperateView)
        containerStackView.addArrangedSubview(stackView_title_lot)
        stackView_title_lot.addArrangedSubview(lasttitleLabel)
        
        NSLayoutConstraint.activate([
            lastSeperateView.heightAnchor.constraint(equalToConstant: CFG.seperateHeight),
            
            stackView_title_lot.topAnchor.constraint(equalTo: lastSeperateView.bottomAnchor),
            
            lasttitleLabel.heightAnchor.constraint(equalToConstant: 35),
            ])
        setMarginStackView(sView: stackView_title_lot, top: CFG.marginTopBotton, left: CFG.marginLeftRight, bottom: CFG.marginTopBotton, right: CFG.marginLeftRight)
        
    }
    
    private func getStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        //view.distribution = .fill
        
        view.distribution =  UIStackView.Distribution.equalSpacing//.fill
        
        return view
    }
    
    private func getLabel(title: String) -> UILabel {
        let label = UILabel().forAutolayout()
        label.text = title
        return label
    }
    
    func fetchPopularizeImage() {
        
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        NoticeAPIClient.getPopularizeImage(ticket: user.ticket) { [weak self] (images, msg) in
            guard let this = self else { return  }
            this.carouselView.updateView(dataSource: images)
        }
    }
    
    func fetchRollMessage() {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        NoticeAPIClient.getRollMsg(ticket: user.ticket, msgType: 0) { [weak self] (rollMsg, msg) in
            guard let this = self else { return  }
            RedEnvelopComponent.shared.rollMsg = rollMsg
            this.messageLabel.updateContent(message: rollMsg)
        }
        
    }
    
    func fetchPopupMessage() {
        if  UserDefaultManager.sharedInstance().isShowPoupMessage() != nil { return }
        
        guard let user = RedEnvelopComponent.shared.user else { return }
        guard let userno = RedEnvelopComponent.shared.userno else { return }
        
        NoticeAPIClient.getPopupMsg(ticket: user.ticket) { [weak self] (message, errormessage) in
            guard let this = self else {return}
            if message.count > 0 {
                UserDefaultManager.sharedInstance().didShowPopupMessage(userno: userno)
                let vc = MessagePopupController(message: message)
                this.popupVc = vc
                vc.modalPresentationStyle = .overCurrentContext
                this.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    func fetchUserStatus() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.startFetchUserStatus()
        }
    }
    
    func fetchListGameLottery() {
        guard let user = RedEnvelopComponent.shared.user else {return}
        
        RedEnvelopAPIClient.listGameLottery(ticket: user.ticket) {[weak self] (gameModels, errormessage) in
            guard let this = self else {return}
            for i in 0..<gameModels.count {
                this.lstLottery.append(gameModels[i])
            }
            
            this.bindLstLotteryToView()
        }
        
    }
    
    func bindLstLotteryToView() {
        var lobbyIndex = 0
        if lstLottery.count <= 0 {
            return
        }
        
        while (lobbyIndex < lstLottery.count){
            //----------Item lottery--------------
            let stackView3 = getStackView()
            containerStackView.addArrangedSubview(stackView3)
            
            let perItemRow:Int = 2;
            let btnLotteryWidth = view.frame.width / CGFloat(perItemRow) - CFG.marginLeftRight * CGFloat(perItemRow)
            let itemHeight_lottery = UIScreen.main.bounds.width / 6//itemHeight
            
            NSLayoutConstraint.activate([
                //stackView3.topAnchor.constraint(equalTo: stackView_title_lot.bottomAnchor),
                stackView3.heightAnchor.constraint(equalToConstant: itemHeight_lottery)
                ])
            
            setMarginStackView(sView: stackView3, top: CFG.marginTopBotton, left: CFG.marginLeftRight, bottom: CFG.marginBottom_lot, right: CFG.marginLeftRight)
            
            for _ in (0..<perItemRow) {
                let button = LobbyItemView(model: lstLottery[lobbyIndex], axis: .horizontal, typeIcon: 2, output: self)
                button.translatesAutoresizingMaskIntoConstraints = false
                stackView3.addArrangedSubview(button)
                
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: btnLotteryWidth),
                    ])
                
                lobbyIndex += 1
                
                if (lobbyIndex >= lstLottery.count) {
                    break;
                }
            }
        }
        
    }
    
}

extension HomeViewController: HomeViewInput {
    func updatePopularizeImage(images: [String]) {
        carouselView.updateView(dataSource: images)
    }
}

extension HomeViewController: HomeViewControllerInput {
    
}

extension HomeViewController: LobbyItemViewOuput {
    func pressedLobbyItem(model: LobbyItemModel) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        if model.action == "lottery" {
            
            RedEnvelopAPIClient.lottery(ticket: user.ticket, gameno: model.key) { (gameurl, def) in
                
                if let url = gameurl {
                    let webController = WebContainerController(url: url)
                    self.present(webController, animated:true, completion:nil)
                }
            }
        }else if model.action == "user" {
            UserAPIClient.otherH5(ticket: user.ticket, optype: model.key) { (abc, def) in
                if let url = abc {
                    let webController = WebContainerController(url: url)
                    self.present(webController, animated:true, completion:nil)
                }
            }
        }else if model.action == "envelop" {
            let key = Int(model.key) ?? 0
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let index =  TabIndex(rawValue:key){
                appDelegate.selectTabIndex(index: index)
            }
        }else{
            
        }
        
    }
    
    
}



