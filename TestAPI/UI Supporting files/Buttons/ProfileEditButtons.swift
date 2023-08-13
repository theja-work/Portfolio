//
//  ProfileEditButtons.swift
//  TestAPI
//
//  Created by Thejas K on 11/08/23.
//

import Foundation
import UIKit

public class ProfileButtons : HomeButtons {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("not implemented")
    }
    
    public func setupStyle(type : ProfileButton) {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(hex: type.buttonColor)
        self.layer.cornerRadius = 8.0
        
        self.titleLabel?.font = type.font
        //self.titleLabel?.textColor = UIColor(hex: type.fontColor)
        self.setTitleColor(UIColor(hex: type.fontColor), for: .normal)
        self.setTitle(type.title, for: .normal)
        
        
    }
    
}

public enum ProfileButton {
    case Edit
    case Save
    
    var buttonColorCode : ColorCodes {
        switch self {
        case .Edit      : return .ButtonBlueLight
        case .Save      : return .ButtonOrange
        }
    }
    
    var buttonTitleColorCode : ColorCodes {
        switch self {
        case .Edit      : return .DarkBlue
        case .Save      : return .DarkBlue
        
        }
    }
    
    var buttonColor : String {
        return self.buttonColorCode.code
    }
    
    var title : String {
        switch self {
        case .Edit      : return "Edit"
        case .Save      : return "Save"
        }
    }
    
    var font : UIFont {
        switch self {
        case .Edit      : return CustomFont.OS_Semibold.font
        case .Save      : return CustomFont.OS_Bold.font
        }
    }
    
    var fontColor : String {
        return self.buttonTitleColorCode.code
    }
}
