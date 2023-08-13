//
//  ProfileViewController.swift
//  TestAPI
//
//  Created by Thejas K on 11/08/23.
//

import Foundation
import UIKit

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
    
    
    @IBOutlet weak var scrollViewContentHeightConstaint: NSLayoutConstraint!
    
    
    public class func viewController() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        
        
        return viewController!
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorCodes.ButtonPurple.color
        
        initialSetup()
        
    }
    
    public func initialSetup() {
        labelSetup()
        buttonSetup()
        
        textFieldSetup()
        profileImageSetup()
        
        scrollViewContentHeightConstaint.constant = CGFloat((self.nameField.frame.height * 3.0) + (40.0 * 6.0) + (self.saveButton.frame.height * 2.0) + (self.view.frame.height * 0.25))
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
        mobileLabel.text = "Mobile" ; mobileLabel.textAlignment = .center
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
    }
    
    @IBAction func editProfileAction(_ sender : ProfileButtons) {
        
        self.editImageToggle.isHidden = false
        self.editImageToggle.image = UIImage(named: "editProfileImage")
        self.view.bringSubviewToFront(editImageToggle)
        
        
        self.nameField.isEnabled = true
        self.mobileField.isEnabled = true
        self.ageField.isEnabled = true
        
        self.nameField.becomeFirstResponder()
        
    }
    
    @IBAction func saveProfileAction(_ sender : ProfileButtons) {
        
        self.editImageToggle.isHidden = true
        self.editImageToggle.image = nil
        self.view.sendSubviewToBack(editImageToggle)
        
        self.nameField.isEnabled = false
        self.mobileField.isEnabled = false
        self.ageField.isEnabled = false
        
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
