//
//  CONST_GUI.swift
//  Gwin
//
//  Created by Macintosh HD on 12/5/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class CONST_GUI {
    //static let FONT_SIZE_ROLL_MESS = UIDevice.current.iPad ? "2" : "12"
    static let HEADER_STANDARD_SPACING:CGFloat = 16
    static let FONT_BIG_COUNTDOWN:CGFloat = UIDevice.current.iPad ? 250.0 : 150.0
    
    static func marginLRAvatarDef() -> CGFloat {
        var height: CGFloat = 6
        if UIDevice.current.iPad {
            height = 30
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 4
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 5
        } else {
            height = 6
        }
        
        return height;
    }
    
    static func heightAvatarDef() -> CGFloat {
        var height: CGFloat = 100
        if UIDevice.current.iPad {
            height = 120
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 70
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 80
        } else {
            height = 90
        }
        
        return height;
    }
    
    static func heightTitleLobby() -> CGFloat {
        var height: CGFloat = 35
        if UIDevice.current.iPad {
            height = 35
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 20
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 25
        } else {
            height = 28
        }
        
        return height;
    }
    
    static func marginLeftRightTitleLobby() -> CGFloat {
        var height: CGFloat = 10
        if UIDevice.current.iPad {
            height = 10
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 10
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 10
        } else {
            height = 10
        }
        
        return height;
    }
    
    static func marginBottomTitleLobby() -> CGFloat {
        var height: CGFloat = 0
        if UIDevice.current.iPad {
            height = 0
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 0
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 0
        } else {
            height = 0
        }
        
        return height;
    }
    
    static func marginBottomLotLobby() -> CGFloat {
        var height: CGFloat = 0
        if UIDevice.current.iPad {
            height = 0
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 0
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 0
        } else {
            height = 0
        }
        
        return height;
    }
    
    static func marginLeftRightLobby() -> CGFloat {
        var height: CGFloat = 5
        if UIDevice.current.iPad {
            height = 5
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 5
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 5
        } else {
            height = 5
        }
        
        return height;
    }
    
    static func marginTopBottonLobby() -> CGFloat {
        var height: CGFloat = 5
        if UIDevice.current.iPad {
            height = 5
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 5
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 5
        } else {
            height = 5
        }
        
        return height;
    }
    
    static func heightSeperateLobby() -> CGFloat {
        var height: CGFloat = 2
        if UIDevice.current.iPad {
            height = 5
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 2
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 2
        } else {
            height = 2
        }
        
        return height;
    }
    
    static func spaceElementRoom() -> CGFloat {
        var height: CGFloat = 2
        if UIDevice.current.iPad {
            height = 15
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 4
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 5
        } else {
            height = 6
        }
        
        return height;
    }
    
    static func defaultMarginRoom() -> CGFloat {
        var height: CGFloat = 8
        if UIDevice.current.iPad {
            height = 3
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 4
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 5
        } else {
            height = 8
        }
        
        return height;
    }
    
    static func widthButtonRuleRoom() -> CGFloat {
        var height: CGFloat = 30
        if UIDevice.current.iPad {
            height = 60
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 20
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 25
        } else {
            height = 30
        }
        
        return height;
    }
    
    static func heightCellRoomGame() -> CGFloat {
        var height: CGFloat = 110
        if UIDevice.current.iPad {
            height = 180
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 90
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 100
        } else {
            height = 110
        }
        
        return height;
    }
    
    static func heightActionMemberCenter() -> CGFloat {
        var height: CGFloat = 30
        if UIDevice.current.iPad {
            height = 50
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 22
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 30
        } else {
            height = 32
        }
        
        return height;
    }
    
    static func heightInfoMemberCenter() -> CGFloat {
        var height: CGFloat = 80
        if UIDevice.current.iPad {
            height = 100
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 60
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 70
        } else {
            height = 80
        }
        
        return height;
    }
    
    static func heightCellMemberCenter() -> CGFloat {
        var height: CGFloat = 40
        if UIDevice.current.iPad {
            height = 60
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            height = 30
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            height = 35
        } else {
            height = 40
        }
        
        return height;
    }
    
    static func fontSizeMemberCenter_avg() -> CGFloat {
        var fontSize: CGFloat = 13
        if UIDevice.current.iPad {
            fontSize = 20
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            fontSize = 11
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            fontSize = 12
        } else {
            fontSize = 13
        }
        return fontSize
    }
    
    static func fontSizeButtonLobby() -> CGFloat {
        var fontSize: CGFloat = 13
        if UIDevice.current.iPad {
            fontSize = 40
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            fontSize = 15
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            fontSize = 17
        } else {
            fontSize = 20
        }
        return fontSize
    }
    
    static func fontSizeRollMessage() -> CGFloat {
        var fontSize: CGFloat = 12
        if UIDevice.current.iPad {
            fontSize = 4
        } else if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            fontSize = 12
        } else if UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            fontSize = 12
        } else {
            fontSize = 10
        }
        return fontSize
    }
    
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR = "iPhone XR"
        case iPhone_XSMax = "iPhone XS Max"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}
