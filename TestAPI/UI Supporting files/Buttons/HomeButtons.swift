//
//  HomeButtons.swift
//  TestAPI
//
//  Created by Thejas K on 06/08/23.
//

import Foundation
import UIKit

public class HomeButtons : UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("not implemented")
    }
    
    public func setupStyle(type : HomeButtonType) {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(hex: type.buttonColor)
        self.layer.cornerRadius = 8.0
        
        self.titleLabel?.font = UIFont(name: type.font, size: 20)
        //self.titleLabel?.textColor = UIColor(hex: type.fontColor)
        self.setTitleColor(UIColor(hex: type.fontColor), for: .normal)
        self.setTitle(type.title, for: .normal)
        
        
    }
    
}

public enum HomeButtonType {
    case Profile
    case Image
    case Video
    case Audio
    
    var buttonColorCode : ColorCodes {
        switch self {
        case .Profile   : return .ButtonBlueLight
        case .Image     : return .ButtonOrange
        case .Audio     : return .ButtonPurple
        case .Video     : return .ButtonBlueDark
        }
    }
    
    var buttonTitleColorCode : ColorCodes {
        switch self {
        case .Profile , .Audio      : return .LimeLight
        default                     : return .DarkBlue
        }
    }
    
    var buttonColor : String {
        return self.buttonColorCode.code
    }
    
    var title : String {
        switch self {
        case .Profile   : return "Profile"
        case .Image     : return "Image"
        case .Audio     : return "Audio"
        case .Video     : return "Video"
        }
    }
    
    var font : String {
        switch self {
        case .Profile   : return "OpenSans-Regular"
        case .Image     : return "OpenSans-Semibold"
        case .Audio     : return "OpenSans-Regular"
        case .Video     : return "OpenSans-Semibold"
        }
    }
    
    var fontColor : String {
        return self.buttonTitleColorCode.code
    }
}

extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
