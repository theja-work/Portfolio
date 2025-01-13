//
//  HomeTabViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class AppCoordinator : UITabBarController {
    
    class func tabController() -> UITabBarController? {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "appTBC") as? UITabBarController
        
        return tabBarVC
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
    }
    
    func configureTabs() {
        
        
    }
    
}
