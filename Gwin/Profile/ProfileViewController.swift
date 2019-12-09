//
//  ProfileViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/22/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: BaseViewController {
    
    @IBAction func pressRefreshBalanceUser(_ sender: Any) {
        fetchUserInfo(showLoading: true)
    }
    
    @IBOutlet weak var holderHorizonMenu: UIStackView!
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var uploadAvatarButton: UIButton!
    
    @IBOutlet weak var allowCreditLabel: UILabel!
    @IBOutlet weak var allowCreateTitleLabel: UILabel!
    
    
    @IBOutlet weak var refresh1Button: UIButton!
    @IBOutlet weak var refresh2Button: UIButton!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var creditTitleLabel: UILabel!
    
    
    @IBOutlet weak var accountnoLabel: UILabel!
    @IBOutlet weak var accountnoTitleLabel: UILabel!
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var acoutnameTitleLabel: UILabel!
    
    
    @IBOutlet weak var heightHorizMenu: NSLayoutConstraint!
    @IBOutlet weak var infoHeightConstraint: NSLayoutConstraint!
    
    private lazy var refreshControl:UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    private var menuItems:[ProfileItemModel] = []
    private var menuHorizItems:[ProfileItemModel] = []
    private var userInfo:UserInfo?
    
    
    @objc func orderUnsettledTapped(_ sender: UITapGestureRecognizer) {
        print("orderUnsettledTapped")
        self.jumpURL(optType: "order_unsettled", title: "冻结金额详情")
    }

    func setupOrderUnsettled() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.orderUnsettledTapped(_:)))
        self.creditLabel.isUserInteractionEnabled = true
        self.creditLabel.addGestureRecognizer(labelTap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        setTitle(title: "我的")
        initDataMenuHoriz()
        initData()
        
        setupViews()
        setupOrderUnsettled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHorizMenu()
        hideBackButton()
        fetchUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initData() {
        if let path = Bundle.main.path(forResource: "ProfileItems", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObj = try JSON(data: data).array
                
                jsonObj?.forEach{ json in
                    let lobby = ProfileItemModel(json: json)
                    menuItems.append(lobby)
                }
            } catch {
                // handle error
                print("ProfileItems error")
            }
        }
    }
    
    func initDataMenuHoriz() {
        if let path = Bundle.main.path(forResource: "MCenterMenuHoriz", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObj = try JSON(data: data).array
                
                jsonObj?.forEach{ json in
                    let lobby = ProfileItemModel(json: json)
                    menuHorizItems.append(lobby)
                }
            } catch {
                // handle error
                print("initDataMenuHoriz")
            }
        }
    }
    
    func setupHorizMenu() {
        holderHorizonMenu.removeAllArrangedSubviews()
        heightHorizMenu.constant = CONST_GUI.heightCellMemberCenter()
        let buttonSize = view.frame.width/3
        
        for i in 0..<3 {
            let itemHorizMenu = MenuHorizItemView(model: menuHorizItems[i])
            itemHorizMenu.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemHorizMenu.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize)),
                ])
            holderHorizonMenu.addArrangedSubview(itemHorizMenu)
            
            itemHorizMenu.menuItemHanler = { [weak self] (optType, title) in
                self?.jumpURL(optType: optType, title: title)
            }
        }
    }
    
    func fetchNewVersion(showLoading: Bool = false) {
        UserAPIClient.appVersion(ticket: "") { [weak self] (newVersion, urlDownload) in
            guard let this = self else { return }
            this.userInfo?.versionNew = newVersion ?? "0"
            this.reloadNewVersion()
        }
    }
    
    @objc func fetchUserInfo(showLoading: Bool = false) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        if showLoading {
            showLoadingView()
        }
        
        UserAPIClient.userInfo(ticket: user.ticket) { [weak self] (userInfo, errorMessage) in
            guard let this = self else { return }
            this.hideLoadingView()
            this.refreshControl.endRefreshing()
            this.userInfo = userInfo
            if let `userInfo` = userInfo {
                print("userInfo \(userInfo)")
                this.accountnoLabel.text = userInfo.accountno
                
                if userInfo.accountname.count > 0 {
                    this.accountNameLabel.text = userInfo.accountname
                } else {
                    this.accountNameLabel.text = userInfo.accountno
                }
                
                this.allowCreditLabel.text = "\(userInfo.allowcreditquota.toFormatedString())"
                this.creditLabel.text = "\(userInfo.usecreditquota.toFormatedString())"
                this.fetchUserImage(ticket: user.ticket, userno: userInfo.accountno)
                this.reloadQrCodeCell()
                
                this.fetchNewVersion()
            } else {
                
            }
            
        }
    }
    
    func fetchUserImage(ticket: String, userno: String) {
        ImageManager.shared.downloadImage(usernos: [userno]) { [weak self] in
            guard let this = self else { return }
            
            if let imagebase64 = ImageManager.shared.getImage(userno: userno) {
                if let imageData = Data(base64Encoded: imagebase64, options: []) {
                    let image  = UIImage(data: imageData)
                    this.avatarImageView.image = image
                }
            }
        }
    }
    
    func setupViews() {
        let fontSize: CGFloat = CONST_GUI.fontSizeMemberCenter_avg()
        
        let font = UIFont.systemFont(ofSize: fontSize)
        allowCreditLabel.font = font
        allowCreateTitleLabel.font = font
        creditLabel.font = font
        creditTitleLabel.font = font
        accountnoLabel.font = font
        accountnoTitleLabel.font = font
        accountNameLabel.font = font
        acoutnameTitleLabel.font = font
        
        //
        infoHeightConstraint.constant = CONST_GUI.heightInfoMemberCenter()
        
        avatarImageView.contentMode = .scaleAspectFit
        uploadAvatarButton.addTarget(self, action: #selector(avatarPressed(_:)), for: .touchUpInside)
        setupTableView()
    }
    
    func setupTableView() {
        if #available(iOS 10.0, *) {
            tableview.refreshControl = refreshControl
        } else {
            tableview.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableview.register(ProfileItemViewCell.self, forCellReuseIdentifier: "profileItemCell")
    }
    
    func logout(){
        
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        showLoadingView()
        UserAPIClient.logout(ticket: user.ticket, guid: user.guid) {[weak self] (result, message) in
            self?.hideLoadingView()
            if result {
                if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.setWellcomeAsRootViewController()
                }
            }
        }
    }
    
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
    
    func jumpURLToBorser(optType: String, title: String? = nil) {
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        showLoadingView()
        UserAPIClient.otherH5(ticket: user.ticket, optype: optType) {[weak self] (url, message) in
            guard let `this` = self else { return }
            this.hideLoadingView()
            if let jumpurl = url {
                guard let url = URL(string: jumpurl) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func reloadQrCodeCell() {
        let indexPath = IndexPath(item: 1, section: 0)
        tableview.beginUpdates()
        tableview.reloadRows(at: [indexPath], with: .none)
        tableview.endUpdates()
    }
    
    func reloadNewVersion() {
        let indexPath = IndexPath(item: 8, section: 0)
        tableview.beginUpdates()
        tableview.reloadRows(at: [indexPath], with: .none)
        tableview.endUpdates()
    }
    
    @objc func avatarPressed(_ sender: UIButton) {
        let vc = UploadImageViewController()
        vc.didUploadImage = { [weak self] image in
            self?.avatarImageView.image = image
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        fetchUserInfo()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        fetchUserInfo(showLoading: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CONST_GUI.heightCellMemberCenter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "profileItemCell", for: indexPath) as? ProfileItemViewCell {
            let item = menuItems[indexPath.row]
            cell.updateContent(data: item, qrcode: self.userInfo?.refercode, isUpdate: self.userInfo?.isUpdateNewversion())
            if item.action ==  ProfileItemAction.qrcode.rawValue {
                cell.didCopyQRCode = { [weak self] in
                    UIPasteboard.general.string = self?.userInfo?.refercode
                }
            } else if item.action ==  ProfileItemAction.version.rawValue {
                cell.didUpdateNewVersion = { [weak self] in
                    UIPasteboard.general.string = self?.userInfo?.refercode
                    
                    self?.jumpURLToBorser(optType: "recommended_app", title: "快乐彩票")
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        if item.action == "webview" {
            jumpURL(optType: item.key, title: item.webTitle)
        } else{
            if item.key == "logout" {
                logout()
            }
        }
    }
}

