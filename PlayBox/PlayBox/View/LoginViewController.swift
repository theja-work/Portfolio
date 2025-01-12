//
//  ViewController.swift
//  PlayBox
//
//  Created by Thejas on 10/01/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    class func navigationController() -> UINavigationController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "LoginNC") as? UINavigationController
        
        return navigationController
        
    }
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: UIButton!
    
    var loader : Loader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setBackgroundColor()
        setupInputFields()
        setupLoader()
        
        
    }
    
    func setupLoader() {
        
        DispatchQueue.main.async {
            self.loader = Loader(frame: .zero)
            
            self.view.addSubview(self.loader!)
            self.view.bringSubviewToFront(self.loader!)
            
            self.loader?.backgroundColor = UIColor.black.withAlphaComponent(0.65)
            self.loader?.clipsToBounds = true
            self.loader?.layer.cornerRadius = 6.0
            
            self.loader?.translatesAutoresizingMaskIntoConstraints = false
            self.loader?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.loader?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.loader?.widthAnchor.constraint(equalToConstant: 50).isActive = true
            self.loader?.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.loader?.isHidden = true
        }
        
    }

    func setBackgroundColor() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.systemYellow.cgColor , UIColor.systemOrange.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.opacity = 0.75
        
        gradientLayer.frame = self.view.bounds
        
        DispatchQueue.main.async {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
    func setupInputFields() {
        
        userNameField.delegate = self
        passwordField.delegate = self
        
        userNameField.keyboardType = .emailAddress
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        if loader?.isHidden == true {
            DispatchQueue.main.async {
                self.loader?.isHidden = false
            }
        }
        
        loader?.isAnimating == true ? loader?.stopAnimating() : loader?.startAnimating()
        
    }
    
    @IBAction func googleSigninAction(_ sender: UIButton) {
        
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case userNameField :
            
            userNameField.resignFirstResponder()
            
        case passwordField :
            
            passwordField.resignFirstResponder()
            
        default : break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let value = textField.text {
            print("begin editing : \(value)")
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if let value = textField.text {
            print("end editing : \(value) : \(reason)")
        }
        
    }
    
}

