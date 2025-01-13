//
//  AppRoutes.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation

enum AppRoutes {
    
    case Login
    case Home
    case Search
    case Profile
    case Details
    
    var storyboardID : String {
        switch self {
            
        case .Login : return "LoginNC"
            
        case .Home : return "HomeVC"
            
        case .Search : return "SearchVC"
            
        case .Profile : return "ProfileVC"
            
        case .Details : return "DetailsVC"
            
        }
    }
    
}
