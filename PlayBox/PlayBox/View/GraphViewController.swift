//
//  GraphViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class GraphViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "GraphVC") as? GraphViewController
        
        return viewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemTeal
    }
    
}
