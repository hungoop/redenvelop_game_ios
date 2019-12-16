//
//  UserInfo.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UserInfo {
    let accountno: String
    let accountname: String
    let allowcreditquota: Float
    let usecreditquota: Float
    let refercode: String
    var versionNew: String
    
    public init(dictionary: JSON) {
        let data =  dictionary["data"]
        accountno = data["accountno"].stringValue
        accountname = data["accountname"].stringValue
        allowcreditquota = data["allowcreditquota"].floatValue
        usecreditquota = data["usecreditquota"].floatValue
        refercode = data["refercode"].stringValue
        versionNew = "0"
    }
    
    func isUpdateNewversion() -> Bool {
        if let currAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if versionNew.compare(currAppVersion, options: .numeric) == .orderedDescending {
                print("\(versionNew) server version is newer \(currAppVersion)")
                
                return true
            }
        }
        return false
    }
}
