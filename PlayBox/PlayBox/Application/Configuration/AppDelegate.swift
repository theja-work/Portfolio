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
    var appRoute : AppRoutes?
    let database = DBManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if database.isLoggedinUser(readFromDb: true) {
            
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                
                guard let strongSelf = self else {return}
                
                if error == nil || user != nil {
                    // Show the app's signed-out state.
                    DispatchQueue.main.async {
                        strongSelf.routeApp(route: .Home)
                    }
                    
                }
            }
            
        }
        else {
            DispatchQueue.main.async {
                self.routeApp(route: .Login)
            }
        }
        
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
        
        window?.rootViewController = AppCoordinator.tabController()
        
        window?.makeKeyAndVisible()
        
    }
    
    func loadLoginScreen() {
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        window?.rootViewController = LoginViewController.navigationController()
        
        window?.makeKeyAndVisible()
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      return false
    }
    
    func logout() {
        
        routeApp(route: .Login)
        
    }

}

