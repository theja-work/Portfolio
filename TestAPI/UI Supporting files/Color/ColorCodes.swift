//
//  ColorCodes.swift
//  TestAPI
//
//  Created by Thejas K on 11/08/23.
//

import Foundation
import UIKit

public enum ColorCodes {
    
    case LimeLight
    case DarkBlue
    case ButtonBlueDark
    case ButtonBlueLight
    case ButtonOrange
    case ButtonPurple
    case HomeBackground
    case LightGreen
    case SkyBlue
    case BlueGray
    case turmeric
    
    var code : String {
        switch self {
        case .LimeLight         : return "#ffffcc"
        case .DarkBlue          : return "#003366"
        case .ButtonBlueLight   : return "#00ace6"
        case .ButtonBlueDark    : return "#0088cc"
        case .ButtonOrange      : return "#ff9966"
        case .ButtonPurple      : return "#9999ff"
        case .HomeBackground    : return "#94b8b8"
        case .LightGreen        : return "#ccffcc"
        case .SkyBlue           : return "#80d4ff"
        case .BlueGray          : return "#50717d"
        case .turmeric          : return "#FFC300"
        }
    }
    
    var color : UIColor {
        
        if let value = UIColor(hex: self.code) {
            return value
        }
        
        return .clear
    }
    
}
