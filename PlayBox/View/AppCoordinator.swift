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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        DispatchQueue.main.async {
            self.tabBar.isHidden = UIDevice.current.orientation.isLandscape
        }
    }
    
    func configureTabs() {
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .white
        
        guard let tabItems = self.tabBar.items , tabItems.count >= 4 else {return}
        
        //Home
        tabItems[0].image = UIImage(named: "home")
        tabItems[0].selectedImage = UIImage(named: "home_selected")
        
        //Search
        tabItems[1].image = UIImage(named: "search")
        tabItems[1].selectedImage = UIImage(named: "search_selected")
        tabItems[1].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -4, right: 0)
        
        //Downloads
        tabItems[2].image = UIImage(named: "downloads_1")
        tabItems[2].selectedImage = UIImage(named: "downloads_selected_1")
        
        //Settings
        tabItems[3].image = UIImage(named: "settings")
        tabItems[3].selectedImage = UIImage(named: "settings_selected")
        
    }
    
}

