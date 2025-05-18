//
//  DownloadsViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/02/25.
//

import Foundation
import UIKit

class DownloadsViewController : UIViewController {
    
    class func viewController() -> DownloadsViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DownloadsVC") as? DownloadsViewController
        
        return viewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
    }
    
    
}
