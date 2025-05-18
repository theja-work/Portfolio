//
//  FontSelector.swift
//  PlayBox
//
//  Created by Thejas on 31/01/25.
//

import Foundation
import UIKit

final class FontSelector {
    
    private var fonts : [FontType]
    static let shared = FontSelector()
    
    private init() {
        
        self.fonts = FontType.allCases
    }
    
    func getDefaultFont() -> UIFont {
        UIFont(name: FontType.BungeeShader.rawValue, size: 18)!
    }
    
    func getDefaultFont() -> FontType {
        .BungeeShader
    }
    
    func getFontFor(index:Int) -> FontType {
        
        if index < fonts.count {
            
            return fonts[index]
            
        }
        
        return getDefaultFont()
    }
    
}

enum FontType : String , CaseIterable {
    
    case BungeeShader = "BungeeShade-Regular"
    case BungeeTint = "BungeeTint-Regular"
    case FasterOne = "FasterOne-Regular"
//    case KeaniaOne = "KeaniaOne-Regular"
//    case MonoFett = "Monofett-Regular"
//    case PublicSans = "PublicSans-VariableFont_wght"
//    case RubikMaze = "RubikMaze-Regular"
    
    var color : UIColor {
        switch self {
        case .BungeeShader : return UIColor.systemMint
        case .FasterOne : return UIColor.systemTeal
//        case .MonoFett : return UIColor.systemTeal
//        case .KeaniaOne : return UIColor.systemBlue
//        case .RubikMaze : return UIColor.systemYellow
        default : return UIColor.white
        }
    }
    
    func getFont() -> UIFont? {
        
        UIFont(name: self.rawValue, size: 26)
    }
    
}
