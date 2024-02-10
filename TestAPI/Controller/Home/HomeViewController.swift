//
//  HomeViewController.swift
//  TestAPI
//
//  Created by Thejas K on 06/08/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import NVActivityIndicatorView

public class HomeViewController : BaseViewController {
    
    @IBOutlet weak var buttonHolder: UIView!
    
    @IBOutlet weak var profileButton: HomeButtons!
    
    @IBOutlet weak var imageButton: HomeButtons!
    
    @IBOutlet weak var audioButton: HomeButtons!
    
    @IBOutlet weak var videoButton: HomeButtons!
    
    public class func HomeViewController() -> HomeViewController {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        return viewController
        
    }
    
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
        
        loader?.showLoader()
        Task { @MainActor in
            
            if await signInWithGoogle() {
                
                loader?.hideLoader()
                let videoVC = VideoViewController.viewController()
                
                self.navigationController?.pushViewController(videoVC, animated: true)
            }
            else {
                
                loader?.hideLoader()
            }
            
        }
    }
    
    @IBAction func videoButtonAction(_ sender: HomeButtons) {
        let videoVC = VideoViewController.viewController()
        
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    public func signInWithGoogle() async -> Bool {
        
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
            //print("signInWithGoogle : uid : \(firebaseUser.uid) : email : \(firebaseUser.email)")
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
    
}
