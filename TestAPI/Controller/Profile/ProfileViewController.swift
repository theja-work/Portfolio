//
//  ProfileViewController.swift
//  TestAPI
//
//  Created by Thejas K on 11/08/23.
//

import Foundation
import UIKit
import CoreData
import TestSDK

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

public class ProfileViewController : UIViewController {
    
    @IBOutlet weak var profileImageView : UIImageView!
    
    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var mobileLabel : UILabel!
    
    @IBOutlet weak var ageLabel : UILabel!
    
    @IBOutlet weak var nameField : UITextField!
    
    @IBOutlet weak var mobileField : UITextField!
    
    @IBOutlet weak var ageField : UITextField!
    
    @IBOutlet weak var editButton : ProfileButtons!
    
    @IBOutlet weak var saveButton : ProfileButtons!
    
    @IBOutlet weak var editImageToggle : UIImageView!
    
    @IBOutlet weak var scrollViewHolder: UIView!
    
    @IBOutlet weak var profileDetailsScrollView: UIScrollView!
    
    @IBOutlet weak var logoutButton: ProfileButtons!
    
    @IBOutlet weak var scrollViewContentHeightConstaint: NSLayoutConstraint!
    
    let testSDKinstance = TestSDKFrameWork.shared
    
    var loader : UIActivityIndicatorView!
    
    public class func viewController() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        
        
        
        return viewController!
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorCodes.BlueGray.color
        
        initialSetup()
        
        getUserData()
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.editImageToggle.isUserInteractionEnabled = false
    }
    
    public func initialSetup() {
        labelSetup()
        buttonSetup()
        
        textFieldSetup()
        profileImageSetup()
        
        scrollViewContentHeightConstaint.constant = CGFloat((self.nameField.frame.height * 3.0) + (40.0 * 6.0) + (self.saveButton.frame.height * 2.0) + (self.view.frame.height * 0.25))
    }
    
    func getUserData() {
        
        var name = ""
        var mobile = ""
        var age = ""
        
        guard let uuid = AppUserDefaults.getCurrentUserUUID() else {return}
        
        guard let user = ProfileMangager().getProfileBy(id: uuid) else {return}
        
        if let name = user.name {
            self.nameField.text = name
        }
        
        if let email = user.email_id {
            self.mobileField.text = email
        }

        if let age = user.age {
            self.ageField.text = age
        }
        
        if let imageData = user.profilePicture , let image = UIImage(data: imageData) {
            
            self.profileImageView.image = image
        }
    }
    
    @objc func editImageToggleAction() {
        
        self.view.endEditing(true)
        
        
        
        ImagePickerManager.shared.pickImage(self) { [weak self] image in
            guard let strongSelf = self else {return}
            
            strongSelf.profileImageView.image = image
        }
        
    }
    
    public func profileImageSetup() {
        self.profileImageView.image = UIImage(named: "profile_placeholder")
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = 12
        self.profileImageView.contentMode = .scaleToFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editImageToggleAction))
        
        self.editImageToggle.addGestureRecognizer(tap)
        self.editImageToggle.clipsToBounds = true
        self.editImageToggle.layer.masksToBounds = true
        self.editImageToggle.layer.cornerRadius = 8
        self.editImageToggle.backgroundColor = .clear
        self.editImageToggle.isOpaque = false
    }
    
    public func textFieldSetup() {
        nameField.delegate = self
        mobileField.delegate = self
        ageField.delegate = self
    }
    
    public func labelSetup() {
        nameLabel.font = CustomFont.OS_Semibold.font
        mobileLabel.font = CustomFont.OS_Semibold.font
        ageLabel.font = CustomFont.OS_Semibold.font
        
        nameLabel.textColor = ColorCodes.DarkBlue.color
        ageLabel.textColor = ColorCodes.DarkBlue.color
        mobileLabel.textColor = ColorCodes.DarkBlue.color
        
        nameLabel.backgroundColor = ColorCodes.ButtonBlueLight.color
        mobileLabel.backgroundColor = ColorCodes.ButtonBlueLight.color
        ageLabel.backgroundColor = ColorCodes.ButtonBlueLight.color
        
        nameLabel.text = "Name" ; nameLabel.textAlignment = .center
        mobileLabel.text = "Email" ; mobileLabel.textAlignment = .center
        ageLabel.text = "Age" ; ageLabel.textAlignment = .center
        
        nameLabel.clipsToBounds = true
        nameLabel.layer.cornerRadius = 6
        
        mobileLabel.clipsToBounds = true
        mobileLabel.layer.cornerRadius = 6
        
        ageLabel.clipsToBounds = true
        ageLabel.layer.cornerRadius = 6
        
    }
    
    public func buttonSetup() {
        editButton.setupStyle(type: .Edit)
        saveButton.setupStyle(type: .Save)
        logoutButton.setupStyle(type: .Logout)
        
    }
    
    func showError(message:String) {
        print("ProfileViewController : \(message)")
    }
    
    @IBAction func editProfileAction(_ sender : ProfileButtons) {
        
        self.editImageToggle.isHidden = false
        self.editImageToggle.image = UIImage(named: "editProfileImage")
        self.view.bringSubviewToFront(editImageToggle)
        
        
        self.nameField.isEnabled = true
        self.mobileField.isEnabled = true
        self.ageField.isEnabled = true
        
        self.nameField.becomeFirstResponder()
        self.editImageToggle.isUserInteractionEnabled = true
        
    }
    
    @IBAction func saveProfileAction(_ sender : ProfileButtons) {
        
        self.editImageToggle.isHidden = true
        self.editImageToggle.image = nil
        self.view.sendSubviewToBack(editImageToggle)
        self.editImageToggle.isUserInteractionEnabled = false
        
        self.nameField.isEnabled = false
        self.mobileField.isEnabled = false
        self.ageField.isEnabled = false
        
        var name = ""
        var mobile = ""
        var age = ""
        var imageData = Data()
        
        if let value = nameField.text {
            name = value
        }
        
        if let value = mobileField.text {
            mobile = value
        }
        
        if let value = ageField.text {
            age = value
        }
        
        if let value = self.profileImageView.image , let data = value.pngData(){
            imageData = data
        }
        else {
            let image = UIImage(named: "place_holder")
            if let data = image?.pngData() {
                imageData = data
            }
        }
        
        guard let current_user_uuid = AppUserDefaults.getCurrentUserUUID() else {return}
        
        guard var user = ProfileMangager().getProfileBy(id: current_user_uuid) else {return}
                
        if !StringHelper.isNilOrEmpty(string: name) {
            user.name = name
        }
        
        if !StringHelper.isNilOrEmpty(string: age) {
            user.age = age
        }
        
        if !StringHelper.isNilOrEmpty(string: mobile) {
            user.email_id = mobile
        }
        
        user.profilePicture = imageData
        
        if ProfileMangager().updateProfile(user: user) {
            print("Profile details updated")
        }
        else {
            print("error saving profile details")
        }
        
    }
    
    @IBAction func logoutUser(_ sender: ProfileButtons) {
        
        let alert = UIAlertController(title: "Are you sure", message: "want to logout?", preferredStyle: .alert)
        
        let canel = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
            
            alert.dismiss(animated: true)
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) {[weak self] okAction in
            
            guard let localSelf = self else {return}
            
            localSelf.logout(userID: "")
        }
        
        alert.addAction(canel)
        alert.addAction(ok)
        
        self.present(alert, animated: true)
        
        
    }
    
    func logout(userID: String) {
        
        AppUserDefaults.current_user_uuid.remove()
        
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.loadLoginScreen()
        }
    }
    
}

extension ProfileViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

extension ProfileViewController : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
