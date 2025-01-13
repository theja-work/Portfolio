//
//  HomeViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        return viewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGreen
    }
    
}
