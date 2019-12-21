//
//  BullModel.swift
//  Gwin
//
//  Created by Hai Vu Van on 9/1/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import CoreData

public enum Packetstatus{
    static let  NO_VALUE: Int  = 0
    static let  GRAB: Int  = 1
    static let  NO_BET: Int  = 2
    static let  PLAYER_GRABED: Int  = 21
    static let  BANKER_GRABED: Int  = 22
    static let  RESULT: Int  = 3
}

public enum RoundStatus: Int {
    case BETING = 1
    case GRAB = 2
    case RESULT = 3
    case NO_VALUE = 0
}

protocol BullModelDelegate: AnyObject {
    func didGetWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel])
    func didGetResultWagerInfo(roundid: Int64, wagerInfos: [BullWagerInfoModel])
    
    //  func didGetResultWagerInfo(roundid: Int64)
}

class BullModel {
    var round: BullRoundModel
    var historyPackage: BullPackageHistoryModel?
    var betWagerInfo: [BullWagerInfoModel] = []
    var resultWagerInfo: [BullWagerInfoModel] = []
    var bullInfo: BullPackageModel?
    
    var openResult: Int
    var isOpen: Bool
    //var expire: Bool
    var roomid: Int
    //var canbet: Bool
    //private var wagerTimer: Timer?
    //var limitCoundown: Int = 0
    //  private var resultWagerTimer: Timer?
    var delegate: BullModelDelegate?
    
    init(round: BullRoundModel, historyPackage: BullPackageHistoryModel?, roomid: Int, delegate: BullModelDelegate? = nil){
        //self.canbet = canbet
        //self.expire = expire
        self.round = round
        self.historyPackage = historyPackage
        self.roomid = roomid
        self.delegate = delegate
        
        self.isOpen = false
        openResult = 0
    }
    
    deinit {
        //cancelWagerTimer()
    }
    
    func updateRoundStatus(status: Int) {
        round.status = status
    }
    
    /*
    func wagerInfoTimer(limit: Int) {
        if wagerTimer == nil{
            limitCoundown = limit // no use
            
            wagerTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchWagerInfo(_:)), userInfo: ["idno": getLastIdno(), "status": 1], repeats: true)
            
            print("wagerInfoTimer \(round.roundid)")
        }
    }*/
    
    func resultWagerInfoTimer(cancelCurrent: Bool = false) {
        fetchResultWagerInfo()
    }
    
    /*
    func cancelWagerTimer(){
        wagerTimer?.invalidate()
        wagerTimer = nil
        
        print("cancelWagerTimer \(round.roundid)")
    }*/
    
    @objc func fetchWagerInfo(_ timer: Timer? = nil) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: getLastIdno()) { [weak self](infos, error) in
            guard let this = self else {return}
            print("fetchWagerInfo \(this.round.roundid) idno \(this.getLastIdno()) count \(infos.count) - stake \(infos.map{$0.stake})")
            
            if infos.count == 0 { return }
            
            if this.addNewWager(wagers: infos) {
                this.delegate?.didGetWagerInfo(roundid:this.round.roundid, wagerInfos: this.betWagerInfo)
            }
        }
    }
    
    @objc func fetchResultWagerInfo(_ timer: Timer? = nil) {
        guard let user = RedEnvelopComponent.shared.user else { return }
        
        BullAPIClient.wagerinfo(ticket: user.ticket, roomid: roomid, roundid: round.roundid, idno: 0) { [weak self](infos, error) in
            guard let this = self else {return}
            print("fetchResultWagerInfo result \(infos.map{$0.winning})")
            
            let winingWagers = infos.filter{$0.winning != 0}
            
            if winingWagers.count == 0 { return }
            
            if this.addResultWager(wagers: winingWagers) {
                this.delegate?.didGetResultWagerInfo(roundid:this.round.roundid,wagerInfos: this.resultWagerInfo)
            }
        }
    }
    
    func isGrabed(_ grabeds: [NSManagedObject] = []) -> Bool {
        let rounid = getRoundId()
        
        for obj in grabeds {
            if rounid == obj.value(forKey: "packageid") as? Int64 {
                self.isOpen = true
                return true
            }
        }
        
        return false
    }
    
    func addNewWager(wagers: [BullWagerInfoModel]) -> Bool{
        var hasNew = false
        for info in wagers {
            var has: Bool = false
            for existInfo in betWagerInfo {
                if info.userno == existInfo.userno && info.idno == existInfo.idno {
                    has = true
                    break
                }
            }
            if !has {
                hasNew = true
                betWagerInfo.append(info)
            }
        }
        return hasNew
    }
    
    func addResultWager(wagers: [BullWagerInfoModel]) -> Bool{
        var hasNew = false
        
        for info in wagers {
            var has: Bool = false
            for existInfo in resultWagerInfo {
                if info.userno == existInfo.userno && info.idno == existInfo.idno {
                    has = true
                    break
                }
            }
            if !has {
                hasNew = true
                resultWagerInfo.append(info)
            }
        }
        return hasNew
    }
    
    func getLastIdno() -> Int{
        if let last = betWagerInfo.last {
            return last.idno
        }
        return 0
    }
    
    func countWagerInfo() -> Int {
        return resultWagerInfo.count + betWagerInfo.count
    }
    
    func isOnleyself() -> Bool {
        if(openResult == Packetstatus.RESULT || openResult == Packetstatus.BANKER_GRABED){
            return false
        } else {
            return true
        }
        
        /*
        if(openResult == Packetstatus.GRAB){
            return true
        } else {
            return false
        }*/
    }
    
    func getRoundId() -> Int64 {
        if let package = historyPackage {
            return package.roundid
        }
        return round.roundid
    }
    
    func getUserno() -> String?{
        if let package = historyPackage {
            return package.userno
        }
        return nil
    }
    
    func myBanker() -> Bool {
        return round.myBanker()
    }
}

