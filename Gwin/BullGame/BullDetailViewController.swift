//
//  BullDetailViewController.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/29/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import WebKit
import CoreData
import SwiftyJSON

protocol UpdateAfterBet {
    func updateBalance()
}

class BullDetailViewController: BaseViewController {
    
    enum Constants {
        static let historyItemWidth: CGFloat = 35
        static let bakerGetText:[String] = ["当前庄家","庄家金额","下注区间","连庄局数","","","","","连庄局数","庄家金额","下注区间","已抢局数"]
        static let bullUserno: String = "平台"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var marqueView: UILabel!
    
    @IBOutlet weak var countdountBetLabel: UILabel!
    
    @IBOutlet weak var countdountGrabLabel: UILabel!
    
    @IBOutlet weak var rollMsgMarqueeView:UIView!
    
    @IBOutlet weak var countdownRoundLabel: UILabel!
    
    @IBOutlet weak var roundHistoryStackView: UIView!
    
    @IBOutlet weak var bankerCountLabel: UILabel!
    @IBOutlet weak var purchaseDetailLabel: UILabel!
    
    @IBOutlet weak var historyViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var action1Button: UIButton!
    @IBOutlet weak var action2Button: UIButton!
    @IBOutlet weak var action3Button: UIButton!
    @IBOutlet weak var action4Button: UIButton!
    @IBOutlet weak var bankerStackView: UIStackView!
    
    @IBOutlet weak var subgameStackView: UIStackView!
    @IBOutlet weak var bottomBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    private lazy var scrollMessageLabel: ScrollLabel = {
        let title = ScrollLabel().forAutolayout()
        title.updateContent(message: "")
        return title
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.imageEdgeInsets  = UIEdgeInsets(top: 5, left: 50, bottom: 20, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        button.imageView?.contentMode = .scaleAspectFit //UIView.ContentMode.center//
        button.setImage(UIImage(named: "boom_header_profile"), for: .normal)
        
        //button.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
        
        button.setTitle("0", for: .normal)
        button.setTitleColor(UIColor(hexString: "FBEAAC"), for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 10.0)
        return button
    }()
    
    
    private lazy var reportBetButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,y: 0,width: 35,height: 35))
        button.imageEdgeInsets  = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "boom_header_envelop"), for: .normal)
        button.addTarget(self, action: #selector(envelopReportPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var bankerGetButton: UIButton = {
        let button = UIButton().forAutolayout()
        button.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        button.addTarget(self, action: #selector(bankgetGetPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshControl:UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    private lazy var bigCountDownControl:UILabel = {
        let bigCountLabel = UILabel().forAutolayout()
        bigCountLabel.textAlignment = .center
        bigCountLabel.textColor =  UIColor.gray
        
        bigCountLabel.font = UIFont.systemFont(ofSize: CONST_GUI.FONT_BIG_COUNTDOWN)
        return bigCountLabel;
    }()
    
    
    private var userno: String
    private var room: RoomModel
    private var round: BullRoundModel?
    
    private var datas: [BullModel] = []
    private var openPackages: [NSManagedObject] = []
    var coundownBet: Int = 0
    var countDownGrab: Int = 0
    var countDownRound: Int = 0
    var firsttime: Bool = true
    private var roundTimmer: Timer?
    
    private var wagerInfo: [Int64: [BullWagerInfoModel]] = [:]
    private var wagerOdds: [BullWagerOddModel] = []
    private var currentViewController: BaseViewController?
    
    init(userno: String, room: RoomModel) {
        self.room = room
        self.userno = userno
        super.init(nibName: "BullDetailViewController", bundle: nil)
        
        print("------BullDetailViewController ----- init------")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "牛牛红包")
        
        profileButton.frame = CGRect(x: 0, y: 0, width: 90, height: 56)
        reportBetButton.frame = CGRect(x: 0, y: 0, width: 35, height: 56)
        
        let rightItem1 = UIBarButtonItem(customView: reportBetButton)
        let rightItem2 = UIBarButtonItem(customView: profileButton)
        self.navigationItem.rightBarButtonItems = [rightItem1, rightItem2]
        
        setupViews()
        
        fetchOpenPackages()
        fetchBullRound()
        
        getBullRollMessage()
        
        //fetchSystemTime()
        
        fetchwagerodds()
        fetchUserInfo()
        
        print("------BullDetailViewController ----- viewDidLoad------")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBottomView()
        
        addBigCount()
    }
    
    func addBigCount() {
        view.addSubview(bigCountDownControl)
        
        NSLayoutConstraint.activate([
            bigCountDownControl.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            bigCountDownControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            bigCountDownControl.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        bigCountDownControl.text = ""
    }
    
    deinit {
        if(roundTimmer != nil){
            roundTimmer!.invalidate()
            roundTimmer = nil
        }
        
        
        print("------BullDetailViewController ----- deinit------")
    }
    
    override func forceDestroy () {
        print("------BullDetailViewController ----- forceDetroy------")
        if(roundTimmer != nil){
            roundTimmer!.invalidate()
            roundTimmer = nil
        }
        
        datas.removeAll()
        openPackages.removeAll()
        wagerInfo.removeAll()
        wagerOdds.removeAll()
        round = nil
        currentViewController = nil
    }
    
    func setupViews() {
        settupRollMess()
        setupBullHistory()
        setupTableView()
        setupBottomView()
        setupBankerGetView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PackageHistoryRightViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryRightViewCell")
        tableView.register(UINib(nibName: "PackageHistoryLeftViewCell", bundle: nil), forCellReuseIdentifier: "PackageHistoryLeftViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func setupBottomView() {
        action1Button.centerVertically()
        action1Button.imageView?.contentMode = .scaleAspectFit
        //
        action2Button.centerVertically()
        action2Button.imageView?.contentMode = .scaleAspectFit
        //
        action3Button.centerVertically()
        action3Button.imageView?.contentMode = .scaleAspectFit
        //
        action4Button.imageView?.contentMode = .scaleAspectFit
        action4Button.centerVertically()
        
        action4Button.isHidden = !room.niuallowchangebanker
    }
    
    func setupBankerGetView() {
        let labelHeight: CGFloat = 17
        let rowCount: Int = 4
        let colCount: Int = 4
        for rowIndex in 0 ..< rowCount {
            let row1 = UIStackView()
            row1.axis = .horizontal
            row1.distribution = .fillEqually
            row1.spacing = 1
            for i in 0 ..< colCount {
                let label = UILabel().forAutolayout()
                if rowIndex % 2 == 0 {
                    label.text = Constants.bakerGetText[i + rowIndex * colCount]
                }else{
                    label.text = "\(i)"
                }
                
                label.textAlignment = .center
                label.backgroundColor = .groupTableViewBackground
                label.tag = rowIndex * colCount + (1 + i)
                label.font = UIFont.systemFont(ofSize: 12)
                row1.addArrangedSubview(label)
                if rowIndex % 2 == 1 {
                    label.textColor = AppColors.tabbarColor
                }
                NSLayoutConstraint.activate([
                    label.heightAnchor.constraint(equalToConstant: labelHeight)
                    ])
            }
            bankerStackView.addArrangedSubview(row1)
            if rowIndex == 1 {
                let seperateView = UIView().forAutolayout()
                bankerStackView.addArrangedSubview(seperateView)
                NSLayoutConstraint.activate([
                    seperateView.heightAnchor.constraint(equalToConstant: 1)
                    ])
            }
        }
        
        bottomView.addSubview(bankerGetButton)
        
        NSLayoutConstraint.activate([
            bankerGetButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
            bankerGetButton.bottomAnchor.constraint(equalTo: bankerStackView.bottomAnchor),
            bankerGetButton.heightAnchor.constraint(equalToConstant: labelHeight * 2),
            bankerGetButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 4 - 1)
            ])
    }
    
    func bindRoundDataViews(round: BullRoundModel) {
        //
        bankerCountLabel.text = "庄家点数走势图 第\(round.nextroundid)期"
        purchaseDetailLabel.text = "账单日期\(round.nextopentime.toString())"
        //
        for row in self.bankerStackView.subviews {
            if row is UIStackView {
                for view in row.subviews {
                    if view is UILabel {
                        //print("label \(view.tag)")
                        if let label = view as? UILabel{
                            let tag = label.tag
                            if tag == 5{
                                label.text = round.banker
                            }else if  tag == 6{
                                label.text = round.lockquota
                            }else if tag == 8{
                                label.text = "\(round.bankqty)"
                            }else if tag == 13{
                                label.text = round.nextbanker
                            }else if tag == 7 {
                                label.text = "\(round.stake1)-\(round.state2)"
                            }else if tag == 14{
                                label.text = "\(round.nextlockquota)"
                            }else if tag == 15{
                                label.text = "\(round.nextstake1 ?? 0)-\(round.nextstake2 ?? 0)"
                            }else if tag == 16{
                                label.text = "\(round.bankround)/\(round.remainround)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func settupRollMess()  {
        rollMsgMarqueeView.addSubview(scrollMessageLabel)
        
        NSLayoutConstraint.activate([
            scrollMessageLabel.topAnchor.constraint(equalTo: rollMsgMarqueeView.topAnchor),
            scrollMessageLabel.bottomAnchor.constraint(equalTo: rollMsgMarqueeView.bottomAnchor),
            scrollMessageLabel.leadingAnchor.constraint(equalTo: rollMsgMarqueeView.leadingAnchor, constant: 5),
            scrollMessageLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -5),
            ])
    }
    
    func setupBullHistory() {
        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 12)
        var leftMargin: CGFloat = 0
        for index in 0 ..< 12 {
            
            leftMargin = (itemWidth) * CGFloat(index)
            let itemView = getHistoryItemView(model: nil)
            
            roundHistoryStackView.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.widthAnchor.constraint(equalToConstant: itemWidth),
                itemView.heightAnchor.constraint(equalTo: roundHistoryStackView.heightAnchor),
                itemView.centerYAnchor.constraint(equalTo: roundHistoryStackView.centerYAnchor),
                itemView.leftAnchor.constraint(equalTo: roundHistoryStackView.leftAnchor, constant: leftMargin)
                ])
        }
    }
    
    func fetchBullRound(){
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.round(firsttime: firsttime, ticket: user.ticket, roomid: room.roomId) { [weak self] (crawlerRound, error) in
            guard let this = self else {return}
            
            if let crawlerRound = crawlerRound {
                //XU LY COUNTDOWN
                this.coundownBet = Int((crawlerRound.endtime.timeIntervalSinceNow - crawlerRound.currtime.timeIntervalSinceNow));
                this.countDownGrab = Int((crawlerRound.winningtime.timeIntervalSinceNow - crawlerRound.currtime.timeIntervalSinceNow));
                this.countDownRound = Int((crawlerRound.nextopentime.timeIntervalSinceNow - crawlerRound.currtime.timeIntervalSinceNow));
                this.doCounDown()
                
                if(this.round == nil || this.round?.roundid != crawlerRound.roundid) {
                    print("New Round \(crawlerRound.roundid), status \(crawlerRound.status) ,datas.count \(this.datas.count)")
                    
                    if(this.round == nil){
                        print("INIT FISRT Round \(crawlerRound.roundid)")
                        this.firsttime = false
                        this.round = crawlerRound
                        this.fetchPackageHistory(roundid: crawlerRound.roundid)
                    } else {
                        //if let index = this.getBullModel(roundid: this.round!.roundid) {
                        //    let bull = this.datas[index]
                            //bull.cancelWagerTimer()
                        //}
                        this.round = crawlerRound
                    }
                    
                    
                    // GRIVEW BANKER INFO
                    this.bindRoundDataViews(round: crawlerRound)
                    //GRIVEW 12 HISTORY
                    this.fetchBullHistory(roundid: crawlerRound.roundid)
                    
                    if(crawlerRound.status != RoundStatus.NO_VALUE.rawValue){
                        this.addNewBull(round: crawlerRound)
                        
                        if let index = this.getBullModel(roundid: crawlerRound.roundid) {
                            if crawlerRound.status != RoundStatus.RESULT.rawValue {
                                //bull.fetchResultWagerInfo()
                                
                                let bull = this.datas[index]
                                bull.fetchWagerInfo()
                            }
                        }
                    }
                } else {
                    //print("Old Round \(crawlerRound.roundid)")
                    
                    if(this.round?.status != crawlerRound.status){
                        print("Old Round \(crawlerRound.roundid) change STATUS \(crawlerRound.status)")
                        
                        if let index = this.getBullModel(roundid: crawlerRound.roundid){
                            let bull = this.datas[index]
                            bull.updateRoundStatus(status: crawlerRound.status)
                            
                            if crawlerRound.status == RoundStatus.GRAB.rawValue {
                                //bull.cancelWagerTimer()
                                bull.fetchWagerInfo()
                            
                                this.reloadCell(at: index)
                                this.tableView.scrollToBottom()
                            } else if crawlerRound.status == RoundStatus.NO_VALUE.rawValue {
                                //bull.cancelWagerTimer()
                                print("before updateRoundStatus \(bull.round.status)")
                                //this.reloadCell(at: index)
                                self!.removePackage(at: index)
                            } else if crawlerRound.status == RoundStatus.RESULT.rawValue {
                                bull.resultWagerInfoTimer()
                                //bull.cancelWagerTimer()
                                // update banker. result???
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    func fetchBullHistory(roundid: Int64) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        BullAPIClient.history(ticket: user.ticket, roomid: room.roomId, roundid: roundid, pagesize: 50) { [weak self] (histories, error) in
            guard let this = self else { return }
            for i in 0 ..< 12 {
                let subview = this.roundHistoryStackView.subviews[i]
                if i < histories.count {
                    let history = histories[i]
                    for item in subview.subviews {
                        if let button  = item as? UIButton {
                            button.setTitle(history.packettag, for: .normal)
                        }else if let label = item as? UILabel {
                            label.text = String("\(history.roundid)".suffix(4))
                        }
                    }
                }else {
                    subview.isHidden = true
                }
            }
        }
    }
    
    func fetchPackageHistory(loadmore: Bool = false, roundid: Int64) {
        if datas.count > 0 && !loadmore { return }
        guard let user = RedEnvelopComponent.shared.user else { return }
        guard let `round` = round else { return }
        
        BullAPIClient.packethistory(ticket: user.ticket, roomid: room.roomId, roundid: roundid, topnum: 10) {[weak self] (histoires, error) in
            guard let this = self else { return }
            this.refreshControl.endRefreshing()
            if histoires.count == 0 {
                return
            }
            
            if let copyRound = round.copy() as? BullRoundModel{
                copyRound.roundid = Int64.max
                //copyRound.status = RoundStatus.GRAB.rawValue
                copyRound.status = RoundStatus.RESULT.rawValue
                
                let reverHistory = histoires.reversed().map{BullModel(round: copyRound, historyPackage: $0, roomid: this.room.roomId)}
                if loadmore {
                    //print("fetchPackageHistory reverHistory add at 0: \(reverHistory)")
                    if reverHistory.count > 0 {
                        this.datas.insert(contentsOf: reverHistory, at: 0)
                        this.tableView.reloadData()
                    }
                } else {
                    //print("fetchPackageHistory reverHistory set new: \(reverHistory)")
                    
                    //this.datas = reverHistory //  code ngu kinh
                    this.datas.insert(contentsOf: reverHistory, at: 0)
                    this.tableView.reloadData()
                    this.tableView.scrollToBottom()
                }
            }
            
        }
    }
    
    func getBullRollMessage() {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.getbullRollMessage(ticket: user.ticket) {[weak self] (rollmsg) in
            guard let this = self else { return  }
            this.scrollMessageLabel.updateContent(message: rollmsg)
        }
    }
    
    func fetchwagerodds() {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.wagerodds(ticket: user.ticket, roomtype: 2) { [weak self](wagerodds, error) in
            guard let this = self else { return }
            this.wagerOdds = wagerodds
        }
        
    }
    
    @objc func fetchUserInfo(showLoading: Bool = false) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        //if showLoading {
            //showLoadingView()
        //}
        
        UserAPIClient.userInfo(ticket: user.ticket) { [weak self] (userInfo, errorMessage) in
            //this.hideLoadingView()
            guard let this = self else { return }
            
            if let `userInfo` = userInfo {
                print("userInfo \(userInfo)")
                this.profileButton.setTitle("\(userInfo.allowcreditquota)", for: .normal)
            }
            
        }
    }
    
    func fetchPacketInfo(){
        guard let user = RedEnvelopComponent.shared.user else { return }
        guard let r = round else {return}
        
        let onlyself = 1
        BullAPIClient.info(ticket: user.ticket, roomid: room.roomId, roundid: r.roundid, onlyself: onlyself) { [weak self](package, model, error) in
            guard let this = self else { return }
            guard let model = model else { return }
            
            if let index = self?.getBullModel(roundid: r.roundid) {
                this.datas[index].bullInfo = model
                this.reloadCell(at: index)
            }
        }
        
    }
    
    
    func getHistoryItemView(model: BullHistoryModel?) -> UIView{
        let view = UIView().forAutolayout()
        
        let padding = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 4 : 8
        let fontSize: CGFloat = UIDevice.current.iPad ? 15 : (UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 9 : 10)
        
        let button = UIButton().forAutolayout()
        let imageWidth = (UIScreen.main.bounds.width / 12) - CGFloat(padding)
        //    button.rounded(radius: imageWidth/2)
        button.setBackgroundImage(UIImage(named: "history_circle_bg"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.setTitleColor(UIColor(hexString: "333333"), for: .normal)
        
        let label = UILabel().forAutolayout()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize - 1)
        label.textColor = AppColors.titleColor
        view.addSubview(button)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.widthAnchor.constraint(equalToConstant: imageWidth),
            button.heightAnchor.constraint(equalToConstant: imageWidth),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: button.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        button.setTitle(model?.packettag, for: .normal)
        if let roundid = model?.roundid{
            label.text = String("\(roundid)".suffix(4))
        }
        return view
    }
    
    func getBullModel(roundid: Int64) -> Int? {
        for i in 0 ..< datas.count {
            let bull = datas[i]
            if bull.round.roundid == roundid {
                return i
            }
        }
        return nil
    }
    
    
    func toggleBottomView() {
        if plusButton.isSelected {
            showBottomView()
            
        }else {
            hideBottomView()
            
        }
    }
    
    func showBottomView(){
        plusButton.isSelected = false
        bottomBottomConstraint.constant = 0
    }
    
    func hideBottomView(){
        plusButton.isSelected = true
        bottomBottomConstraint.constant = bottomHeightConstraint.constant - 30
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        if let first = datas.first{
            fetchPackageHistory(loadmore: true, roundid: first.getRoundId())
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    @objc func bankgetGetPressed(_ button: UIButton){
        guard let `round` = round else {return}
        let vc = BankerViewController(roomid: room.roomId, roundid: round.roundid)
        
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        toggleBottomView()
        tableView.scrollToBottom()
    }
    
    @IBAction func bullSubgamePressed(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 4 {
            let vc = GrabBankerViewController(room: room)
            currentViewController = vc
            vc.updateAfterBet = self
            present(vc, animated: true, completion: nil)
        } else {
            guard let `round` = round else { return }
            
            if coundownBet < 0 {
                subgameStackView.isHidden = coundownBet <= 0
            }
            
            if tag == 1 {
                let _wagerOdds = wagerOdds.clone()
                let vc = BetBullViewController(room: room, round: round, delegate: self, wagerOdds: _wagerOdds)
                currentViewController = vc
                vc.updateAfterBet = self
                present(vc, animated: true, completion: nil)
            } else  if tag == 2 {
                let _wagerOdds = wagerOdds.clone()
                let vc = BetCasinoViewController(room: room, round: round, wagertypeno: Wagertypeno.casino.rawValue, wagerOdds: _wagerOdds)
                currentViewController = vc
                vc.updateAfterBet = self
                present(vc, animated: true, completion: nil)
            } else  if tag == 3 {
                let _wagerOdds = wagerOdds.clone()
                let vc = BetCasinoViewController(room: room, round: round, wagertypeno: Wagertypeno.other.rawValue, wagerOdds: _wagerOdds)
                currentViewController = vc
                
                vc.updateAfterBet = self
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func envelopReportPressed(_ button: UIButton) {
        guard let `user` = RedEnvelopComponent.shared.user else { return }
        UserAPIClient.otherH5(ticket: user.ticket, optype: "orderdetail_2") {[weak self] (url, message) in
            guard let `this` = self else { return }
            
            if let jumpurl = url {
                let webview = WebContainerController(url: jumpurl, title: "牛牛账单详情")
                this.present(webview, animated: true, completion: nil)
            }
        }
        
    }
    
}

extension BullDetailViewController{
    fileprivate func doCounDown() {
        
        if(roundTimmer == nil){
            roundTimmer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBullSubView), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateBullSubView() {
        coundownBet -= 1
        countDownGrab -= 1
        countDownRound -= 1
        
        if let `round` = round{
            marqueView.text = "期数\(round.roundid)"
        }
        countdountBetLabel.text = String(format: "下注时间%2d秒", coundownBet >= 0 ? coundownBet : 0)
        
        countdountGrabLabel.text = String(format: "抢包时间%2d秒", countDownGrab >= 0 ? countDownGrab : 0)
        
        countdownRoundLabel.text = String(format: " 新一轮开始%d秒",countDownRound >= 0 ? countDownRound : 0)
        
        subgameStackView.isHidden = coundownBet <= 0
        
        if coundownBet <= 0 {
            fetchBullRound()
            roundTimmer?.invalidate()
            roundTimmer = nil
        }else if coundownBet == 3 {
            //an man hinh bet khi thoi gian bet con 3s
            currentViewController?.dismiss(animated: true, completion: nil)
        } else if(coundownBet % 5 == 0){
            print("====Update wager data====")
            
            if let index = getBullModel(roundid: round!.roundid) {
                let bull = datas[index]
                bull.fetchWagerInfo()
            }
        }
        
        if (coundownBet < 6 && coundownBet > -1) {
            print("===Bigben: =====\(coundownBet)========")
            bigCountDownControl.text = "\(coundownBet)"
            bigCountDownControl.isHidden = false;
        } else {
            bigCountDownControl.isHidden = true;
        }
    }
    
    
}
extension BullDetailViewController {
    
    fileprivate func addNewBull(round: BullRoundModel){
        let newBull = BullModel(round: round, historyPackage: nil, roomid: room.roomId, delegate: self)
        
        datas.append(newBull)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: datas.count - 1, section: 0)], with: .none)
        tableView.endUpdates()
        tableView.scrollToBottom()
    }
    
    fileprivate func createDumpPackage(round: BullRoundModel)  -> BullModel{
        
        var package:BullPackageHistoryModel? = nil
        var dict:[String: Any] = [:]
        dict["roundid"] = round.roundid
        dict["userno"] = Constants.bullUserno
        dict["username"] = Constants.bullUserno
        dict["wagertime"] = round.winningtime.toString()//"\(Date().toString())"
        
        if let json = JSON(rawValue: dict) {
            package =  BullPackageHistoryModel(json: json)
        }
        
        return  BullModel(round: round, historyPackage: package, roomid: room.roomId, delegate: self)
        
    }
    
    fileprivate func fetchOpenPackages() {
        if let userno = RedEnvelopComponent.shared.userno {
            openPackages = LocalDataManager.shared.fetchPackages(userno: userno, game: RoomType.bull)
        }
    }
    
    private func isOpenPackage(packageid: Int64) -> Bool {
        for obj in openPackages {
            if packageid == obj.value(forKey: "packageid") as? Int64 {
                return true
            }
        }
        return false
    }
}

extension BullDetailViewController{
    
    fileprivate func removePackage(at index: Int) {
        datas.remove(at: index)
        
        let lastIndexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.deleteRows(at: [lastIndexPath], with: .none)
        tableView.endUpdates()
    }
    
    private func updateCellAsOpened(rounid: Int64){
        if let index = getBullModel(roundid: rounid) {
            let indexPath = IndexPath(row: index, section: 0)
            let bull = datas[indexPath.row]
            let isGrab = bull.isGrabed(openPackages)
            if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
                cell.selectionStyle = .none
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak cell] in
                    cell?.updateBullViews(bull: bull, isOpen: isGrab)
                }
            }
        }
    }
    
    private func reloadCell(at index: Int) {
        
        let indexPath = IndexPath(row: index, section: 0)
        /*
            let bull = datas[indexPath.row]
        
            let isGrab = bull.isGrabed(openPackages)
            if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
                cell.selectionStyle = .none
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak cell] in
                    cell?.updateBullViews(bull: bull, isOpen: isGrab)
                }
            }
        */
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
}
extension BullDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bull count \(datas.count)")
        
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt 1 count \(datas.count)")
        
        let bull = datas[indexPath.row]
        let isGrab = bull.isGrabed(openPackages)
        
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "PackageHistoryLeftViewCell", for: indexPath) as? PackageHistoryLeftViewCell {
            cell.selectionStyle = .none
            cell.updateBullViews(bull: bull, isOpen: isGrab)
            return cell
        }
        
        //print("cellForRowAt 2 count \(datas.count)")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bull = datas[indexPath.row]
        
        if bull.round.status == RoundStatus.NO_VALUE.rawValue ||
            bull.round.status == RoundStatus.BETING.rawValue {
            return
        }
        
        let isGrab = bull.isGrabed(openPackages)
        
        if isGrab {
            fetchPackageStatus(bull: bull)
        } else {
            let vc = GrabBullPackageViewController(bull: bull)
            vc.modalPresentationStyle = .overCurrentContext
            
            vc.didGrabPackage = {  [weak self] grabbed in
                guard let this = self else { return }
                if let userno = RedEnvelopComponent.shared.userno {
                    if let saved = LocalDataManager.shared.savePackage(userno: userno, packageid: bull.getRoundId(), game: RoomType.bull) {
                        this.openPackages.append(saved)
                        this.updateCellAsOpened(rounid: bull.getRoundId())
                    }
                }
                
                let infoVC = BulllPackageInfoViewController(bull: bull, grabedModel: grabbed, delegate: this)
                this.present(infoVC, animated: true, completion: nil)
            }
            
            vc.didViewPackageInfo = { [weak self] in
                guard let this = self else { return }
                
                let infoVC = BulllPackageInfoViewController(bull: bull, delegate: this)
                this.present(infoVC, animated: true, completion: nil)
            }
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    func fetchPackageStatus(bull: BullModel) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.packetstatus(ticket: user.ticket, roomid: bull.roomid , roundid: bull.getRoundId()) {[weak self](status, error) in
            guard let this = self else {return}
            if let `status` = status{
                bull.openResult = status
            }
            
            let infoVC = BulllPackageInfoViewController(bull: bull)
            this.present(infoVC, animated: true, completion: nil)
        }
    }
    
}

extension BullDetailViewController: BullModelDelegate {
    func didGetWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel]) {
        if let index = getBullModel(roundid: roundid) {
            let bull = datas[index]
            bull.betWagerInfo = wagerInfos
            //bull.canbet = coundownBet > 0
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            tableView.scrollToBottom()
        }
    }
    
    func didGetResultWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel]) {
        if let index = getBullModel(roundid: roundid) {
            datas[index].resultWagerInfo = wagerInfos
            //datas[index].canbet = false
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            tableView.scrollToBottom()
            
            if (round?.myBanker() ?? false){
                fetchPacketInfo()
            }
            
        }
    }
}

extension BullDetailViewController: BetBullDelegate {
    func didGrabBullPackage() {
        //fetchUserInfo()
        
        subgameStackView.isHidden = true
        hideBottomView()
        guard let `round` = round else { return}
        
        if getBullModel(roundid: round.roundid) == nil {
            addNewBull(round: round)
        }
    }
}

extension BullDetailViewController: BulllPackageInfoDelegate {
    func didFetchPackageInfo(package: BullPackageHistoryModel?) {
        if let `package` = package {
            if let index = getBullModel(roundid: package.roundid) {
                datas[index].historyPackage = package
            }
        }
    }
}

extension BullDetailViewController:UpdateAfterBet {
    func updateBalance() {
        fetchUserInfo()
    }
    
}





