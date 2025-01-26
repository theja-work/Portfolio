//
//  SearchViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class SearchViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController
        
        return viewController
        
    }
    
    
    @IBOutlet weak var optionsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemCyan
        
        
        
    }
    
    @IBAction func selectPhotoAction(_ sender : UIAction) {
        print("selectPhotoAction")
        optionsButton.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func viewPhotoAction(_ sender : UIAction) {
        print("viewPhotoAction")
        optionsButton.setTitle(sender.title, for: .normal)
    }
    
}
