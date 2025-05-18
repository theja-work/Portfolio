//
//  AppDelegate.swift
//  PlayBox
//
//  Created by Thejas on 10/01/25.
//

import UIKit
import CoreData
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orientation : UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func routeApp(route:AppRoutes = AppRoutes.Login) {
        
        switch route {
        case .Login:
            loadLoginScreen()
        case .Home:
            loadAppCoordinator()
        default : break
        }
        
    }
    
    func loadAppCoordinator() {
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        setRootViewController(rootViewController: AppCoordinator.tabController(), animated: true)
        
        window?.makeKeyAndVisible()
        
    }
    
    func loadLoginScreen() {
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        setRootViewController(rootViewController: LoginViewController.navigationController(), animated: true)
        
        window?.makeKeyAndVisible()
        
    }
    
    func setRootViewController(rootViewController : UIViewController? , animated : Bool = false) {
        
        guard let window = window else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
            return
        }
        
        if animated {
            let animationOptions: UIView.AnimationOptions = .transitionCrossDissolve
            
            rootViewController?.view.alpha = 0.0
            UIView.transition(with: window, duration: 0.2, options: animationOptions, animations: {
                window.rootViewController = rootViewController
                rootViewController?.view.alpha = 1.0
            })
        } else {
            window.rootViewController = rootViewController
        }
        
    }

    func logout() {
        
        routeApp(route: .Login)
        
    }
    
    //MARK: - Orientation Management
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        orientation
    }

}

