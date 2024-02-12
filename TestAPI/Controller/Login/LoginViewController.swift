//
//  LoginViewController.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 10/02/24.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import NVActivityIndicatorView
import CoreData

public class LoginViewController : BaseViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerLabel: UILabel!
    
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: UIButton!
    
    @IBOutlet weak var appleSignInButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    public class func viewController() -> LoginViewController {
        
        //LoginVC
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        
        return viewController
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppOrientation.lockOrientation(.portrait)
    }
    
    func setupUI() {
        self.view.backgroundColor = ColorCodes.SkyBlue.color
        
        setupAppWelcomeImage()
        setupUsernameField()
        setupPasswordField()
        setupLoginButton()
        setupRegisterLabel()
        setupOrLabel()
        setupGoogleSignInButton()
        setupAppleSignInButton()
    }
    
    func setupAppWelcomeImage() {
        loginImageView.image = UIImage(named: "AppIcon")
        loginImageView.clipsToBounds = true
        loginImageView.layer.masksToBounds = true
        loginImageView.layer.cornerRadius = 8.0
        loginImageView.contentMode = .scaleToFill
    }
    
    func setupUsernameField() {
        usernameField.placeholder = "Username : John Doe"
    }
    
    func setupPasswordField() {
        passwordField.placeholder = "Password : •••••••••"
    }
    
    func setupLoginButton() {
        loginButton.backgroundColor = ColorCodes.turmeric.color
        loginButton.clipsToBounds = true
        loginButton.layer.masksToBounds = false
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
    }
    
    func setupRegisterLabel() {
        
        let text = "not a member? Register here"
        let attriString = NSMutableAttributedString.init(string:text)
        let nsRange = NSString(string: text)
                .range(of: "Register here", options: String.CompareOptions.caseInsensitive)
        
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorCodes.DarkBlue.color, range: nsRange)
        
        registerLabel.attributedText = attriString
        //registerLabel.backgroundColor = ColorCodes.ButtonOrange.color
        
    }
    
    func setupOrLabel() {
        orLabel.text = "OR"
        orLabel.clipsToBounds = true
        orLabel.layer.masksToBounds = true
        orLabel.layer.cornerRadius = orLabel.frame.size.height / 2
        orLabel.backgroundColor = ColorCodes.ButtonOrange.color
    }
    
    func setupGoogleSignInButton() {
        googleSignInButton.backgroundColor = ColorCodes.HomeBackground.color
        googleSignInButton.clipsToBounds = true
        googleSignInButton.layer.masksToBounds = false
        googleSignInButton.layer.cornerRadius = googleSignInButton.frame.height / 2
        googleSignInButton.setTitle("Signin with Google", for: .normal)
        googleSignInButton.setTitleColor(ColorCodes.DarkBlue.color, for: .normal)
    }
    
    func setupAppleSignInButton() {
        appleSignInButton.backgroundColor = ColorCodes.HomeBackground.color
        appleSignInButton.clipsToBounds = true
        appleSignInButton.layer.masksToBounds = false
        appleSignInButton.layer.cornerRadius = appleSignInButton.frame.height / 2
        appleSignInButton.setTitle("Signin with Apple", for: .normal)
        appleSignInButton.setTitleColor(ColorCodes.DarkBlue.color, for: .normal)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        toast?.showToast(controller: self, text: "Please use google sign in", seconds: 3.0)
    }
    
    
    @IBAction func googleSignInAction(_ sender: Any) {
        
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
    
    
    @IBAction func appleSigninAction(_ sender: UIButton) {
        toast?.showToast(controller: self, text: "Please try again later", seconds: 3.0)
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
            Profile.login(userID: firebaseUser.uid, email_id: firebaseUser.email ?? "")
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameField {
            
            textField.resignFirstResponder()
            
            return true
        }
        
        if textField == passwordField {
            
            textField.resignFirstResponder()
            
            return true
        }
        
        return true
    }
    
}
