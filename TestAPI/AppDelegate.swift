//
//  AppDelegate.swift
//  TestAPI
//
//  Created by Thejas K on 06/08/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setStaringScreen()
        
        var newArguments = ProcessInfo.processInfo.arguments
        newArguments.append("-FIRDebugEnabled")
        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        
        FirebaseApp.configure()
        var params : [String:Any] = [String:Any]()
        params["App_name"] = "Test API"
        if let version : String = Bundle.main.infoDictionary?.valueFor(key: "app_version") {
            params["App_version"] = version
        }
        
        if let id:String = Bundle.main.bundleIdentifier {
            params["Bundle_ID"] = id
        }
        
        Analytics.logEvent("App_launch_event", parameters: params)
        
        return true
    }
    
    func setStaringScreen() {
        
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
        
    }
    
    func setLoginScreen() {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        
        window?.rootViewController = rootVC
    }
    
    func setHomeScreen() {
        
        let rootVC = HomeViewController.HomeViewController()
        
        window?.rootViewController = rootVC
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }

}

struct AppOrientation {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
