//
//  CustomFonts.swift
//  TestAPI
//
//  Created by Thejas K on 11/08/23.
//

import Foundation
import UIKit

public enum CustomFont {
    case OS_Bold
    case OS_Regular
    case OS_Semibold
    case OS_Bold_Italic
    case OS_Semibold_Italic
    
    var name : String {
        switch self {
        case .OS_Bold           : return "OpenSans-Bold"
        case .OS_Regular        : return "OpenSans-Regular"
        case .OS_Semibold       : return "OpenSans-Semibold"
        case .OS_Bold_Italic    : return "OpenSans-BoldItalic"
        case .OS_Semibold_Italic: return "OpenSans-SemiboldItalic"
        }
    }
    
    var font : UIFont {
        if let value = UIFont(name: self.name, size: size) {
            return value
        }
        
        return UIFont()
    }
    
    var size : CGFloat {
        switch self {
        case .OS_Bold           : return 20.0
        case .OS_Regular        : return 18.0
        case .OS_Semibold       : return 16.0
        case .OS_Bold_Italic    : return 14.0
        case .OS_Semibold_Italic: return 12.0
        }
    }
}
