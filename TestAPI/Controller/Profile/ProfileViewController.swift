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
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
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
        
        //guard let context = self.context else {return}
        
//        DispatchQueue.main.async {
//            do {
//                let fetch = try context.fetch(Profile.fetchRequest())
//
//                print(fetch)
//
//                guard let user = fetch.first else {return}
//
//                if let value = user.name , value.count != 0 {
//                    self.nameField.text = value
//                }
//                else {
//                    self.showError(message: "No name found , \(user.name)")
//                }
//
//                if let value = user.mobile , value.count != 0 {
//                    self.mobileField.text = value
//                }
//                else {
//                    self.showError(message: "No mobile number found , \(user.mobile)")
//                }
//
//                if let value = user.age , value.count != 0 {
//                    self.ageField.text = value
//                }
//                else {
//                    self.showError(message: "No age found \(user.age)")
//                }
//
//                if let value = user.profilePicture {
//                    if self.testSDKinstance.setupImageForView(view: self.profileImageView, from: value) == false {
//                        if let image = UIImage(data: value) {
//                            self.profileImageView.image = image
//                        }
//                        else {
//                            self.showError(message: "Erro getting sdk for image setup")
//                        }
//                    }
//                }
//                else {
//                    self.showError(message: "No profile picture")
//                }
//            }
//
//            catch {
//                print(error)
//            }
//        }
        
        
        // old method
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Profile")

        request.returnsObjectsAsFaults = false

        do {
            guard let context = self.context else {return}

            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {
                if let value = data.value(forKey: "name") as? String {
                    name = value
                }

                if let value = data.value(forKey: "email_id") as? String {
                    mobile = value
                }

                if let value = data.value(forKey: "age") as? String {
                    age = value
                }

                if let value = data.value(forKey: "profilePicture") as? Data {

                    if testSDKinstance.setupImageForView(view: self.profileImageView, from: value) == false {

                        if let image = UIImage(data: value) {
                            self.profileImageView.image = image
                        }

                    }

                }
            }

        }

        catch {
            print(error)
        }

        if name.count != 0 {
            self.nameField.text = name
        }

        if mobile.count != 0 {
            self.mobileField.text = mobile
        }

        if age.count != 0 {
            self.ageField.text = age
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
        else {
            name = "John Doe"
        }
        
        if let value = mobileField.text {
            mobile = value
        }
        else {
            mobile = "0000 000 000"
        }
        
        if let value = ageField.text {
            age = value
        }
        else {
            age = "000"
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
        
        guard let context = self.context else {return}
        
        let user = Profile(context: context)
        
        user.name = name
        user.mobile = mobile
        user.age = age
        user.profilePicture = imageData
        
        do {
            try context.save()
        }
        catch {
            print(error)
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
        
        Profile.logout(userID: userID)
        
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
