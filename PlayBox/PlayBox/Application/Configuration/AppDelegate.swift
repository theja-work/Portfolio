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
    
    var changesSaved : Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            
            guard let strongSelf = self else {return}
            
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("Signed out user : \(error?.localizedDescription)")
                DispatchQueue.main.async {
                    strongSelf.routeApp(route: .Login)
                }
            } else {
                // Show the app's signed-in state.
                print("Signed in user : \(user?.profile?.email)")
                DispatchQueue.main.async {
                    strongSelf.routeApp(route: .Home)
                }
            }
        }
        
        //GIDSignIn.sharedInstance.signOut()
        
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PlayBox")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                changesSaved = true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                changesSaved = false
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      return false
    }

}

