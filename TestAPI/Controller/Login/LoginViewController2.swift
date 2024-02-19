//
//  LoginViewController2.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 19/02/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import NVActivityIndicatorView
import CoreData

public class LoginViewController2 : BaseViewController {
    
    public class func getNavigationController() -> UINavigationController {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "LoginNC2") as! UINavigationController
        
        let viewController = navigationController.viewControllers.first as! LoginViewController2
        viewController.buttonSetup()
        
        return navigationController
    }
    
    @IBOutlet weak var signInButton: UIButton!
    
    private let profileManager : ProfileMangager = ProfileMangager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func buttonSetup() {
        self.view.backgroundColor = .black
        
        self.signInButton.clipsToBounds = true
        self.signInButton.layer.masksToBounds = true
        self.signInButton.layer.cornerRadius = 2.0
        
        self.signInButton.setImage(UIImage(named: "signInLogo"), for: .normal)
        self.signInButton.setTitle("Sign in with Google", for: .normal)
        self.signInButton.setTitleColor(ColorCodes.SignInTextColor.color, for: [.normal,.highlighted,.selected])
        self.signInButton.titleLabel?.font = CustomFont.Roboto_Regular.font.withSize(14)
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        loader?.showLoader()
        Task { @MainActor in
            
            if await googleSignInAction() {
                loader?.hideLoader()
                
                DispatchQueue.main.async {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.loadHomeScreen()
                    }
                }
            }
            else {
                loader?.hideLoader()
            }
        }
        
    }
    
    func googleSignInAction() async -> Bool {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false}

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first , let rootViewController = window.rootViewController else {return false}
        
        do {
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
            let user = userAuth.user
            
            guard let idToken = user.idToken else {return false}
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("signInWithGoogle : uid : \(firebaseUser.uid) : email : \(firebaseUser.email) ")
            self.login(user_id: firebaseUser.uid, email_id: firebaseUser.email)
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
    
    func login(user_id:String,email_id:String?) {
        
        if let user = profileManager.getProfileBy(user_id: user_id) {
            
            AppUserDefaults.current_user_uuid.setValue(user.id.uuidString)
        }
        else {
            let user_uuid = UUID()
            
            AppUserDefaults.current_user_uuid.setValue(user_uuid.uuidString)
            
            let user = UserProfile(email_id: email_id, user_id: user_id , id: user_uuid)
            
            profileManager.createProfile(user: user)
        }
        
        
    }
}
