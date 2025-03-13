//
//  SplashViewController.swift
//  PlayBox
//
//  Created by Thejas on 26/02/25.
//

import Foundation
import UIKit
import GoogleSignIn

class SplashViewController : UIViewController {
    
    class func viewController() -> SplashViewController {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var loader: Loader!
    private let database = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        loader.showLoader()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForLogin()
    }
    
    func setBackground() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.systemBlue.cgColor , UIColor.white.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        gradientLayer.type = .radial
        gradientLayer.opacity = 0.85
        
        DispatchQueue.main.async {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
    func checkForLogin() {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            if self.database.isLoggedinUser(readFromDb: true) {
                
                GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user , error in
                    
                    guard let strongSelf = self else {return}
                    
                    
                    strongSelf.loader.hideLoader()
                    
                    if user != nil && error == nil {
                        
                        delegate.routeApp(route: .Home)
                    }
                    else {
                        
                        delegate.routeApp(route: .Login)
                    }
                    
                }
                
            }
            else {
                
                self.loader.hideLoader()
                
                delegate.routeApp(route: .Login)
                
            }
            
        })
    }
    
}
