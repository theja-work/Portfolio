//
//  HomeViewController.swift
//  TestAPI
//
//  Created by Thejas K on 06/08/23.
//

import Foundation
import UIKit

public class HomeViewController : UIViewController {
    
    @IBOutlet weak var buttonHolder: UIView!
    
    @IBOutlet weak var profileButton: HomeButtons!
    
    @IBOutlet weak var imageButton: HomeButtons!
    
    @IBOutlet weak var audioButton: HomeButtons!
    
    @IBOutlet weak var videoButton: HomeButtons!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorCodes.HomeBackground.color
        setupButtons()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func setupButtons() {
        profileButton.setupStyle(type: .Profile)
        imageButton.setupStyle(type: .Image)
        audioButton.setupStyle(type: .Audio)
        videoButton.setupStyle(type: .Video)
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
        let profileVC = ProfileViewController.viewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func audioButtonAction(_ sender: HomeButtons) {
        
    }
    
    @IBAction func videoButtonAction(_ sender: HomeButtons) {
        let videoVC = VideoViewController.viewController()
        
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    
}
