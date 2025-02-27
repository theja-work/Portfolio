//
//  ProfileViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit
import GoogleSignIn
import PhotosUI

class ProfileViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var createdOnLabel: UILabel!
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    private var selectProfilePic = false
    
    let dbManager = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemMint
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showUserDetails()
    }
    
    @IBAction func addProfilePicAction(_ sender : UIAction) {
        
        selectProfilePic = PhotoOptions.getSelection(type: sender.title) != .SelectPhoto
        
        print("\(selectProfilePic) : \(sender.title)")
        
        selectPhotoButton.setTitle("", for: .normal)
        
        if !selectProfilePic {
            openGallery()
        }
        else {
            showProfilePic()
        }
        
    }
    
    func showProfilePic() {
        
        if let image = profileImageView?.image {
            let photoEditorVC = PhotoEditorViewController(editingDelegate: self)
            present(photoEditorVC, animated: true)
            photoEditorVC.setupImage(image: image)
        }
    }
    
    func showUserDetails() {
        
        if let user = dbManager.getUser() , let profile = user.adult {
            
            DispatchQueue.main.async {
                
                
                self.nameLabel.text = user.name
                self.emailLabel.text = user.email
                
                self.ageLabel.text = "Age : \(profile.age)"
                self.genderLabel.text = profile.gender
                
                if let created = profile.createdOn?.formatted() {
                    self.createdOnLabel.text = "Created on : " + created
                }
                
                if let imageData = profile.profilePic , let image = UIImage(data: imageData) {
                    self.profileImageView.image = image
                    self.profileImageView.backgroundColor = .clear
                    self.profileImageView.alpha = 1
                }
                
                self.profileImageView.image == nil ? self.selectPhotoButton.setTitle("Select Photo", for: .normal) : self.selectPhotoButton.setTitle("", for: .normal)
                
                self.nameLabel.setNeedsLayout()
                self.nameLabel.layoutIfNeeded()
                
                self.emailLabel.setNeedsLayout()
                self.emailLabel.layoutIfNeeded()
                
                self.profileImageView.setNeedsLayout()
                self.profileImageView.layoutIfNeeded()
                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func deleteUser() {
        dbManager.deleteUser()
        
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.logout()
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signOut()
        
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.logout()
            }
        }
        
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure want to delete your account?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            
            alert.dismiss(animated: true)
            
            self?.deleteUser()
            
        }
        
        let cancel = UIAlertAction(title: "No", style: .destructive) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    func openGallery() {
        
        var configuaration = PHPickerConfiguration()
        
        configuaration.filter = .images
        configuaration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuaration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
}

extension ProfileViewController : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        print("Picker delegate called")
        
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                
                guard let localSelf = self else {return}
                
                if let uiImage = image as? UIImage {
                    
                    DispatchQueue.main.async {
                        
                        localSelf.profileImageView.image = uiImage
                        localSelf.profileImageView.backgroundColor = .clear
                        localSelf.profileImageView.alpha = 1.0
                        localSelf.selectPhotoButton.setTitle("", for: .normal)
                        localSelf.dbManager.saveProfilePic(image: uiImage)
                        
                    }
                }
            }
        }
        
    }
    
}

extension ProfileViewController : PhotoEditingProtocol {
    
    func applyFilter(image: UIImage) {
        
        DispatchQueue.main.async {
            self.profileImageView.image = image
            
            self.profileImageView.setNeedsLayout()
            self.profileImageView.layoutIfNeeded()
        }
        
    }
    
    func removeFilter(image: UIImage) {
        DispatchQueue.main.async {
            self.profileImageView.image = image
            
            self.profileImageView.setNeedsLayout()
            self.profileImageView.layoutIfNeeded()
        }
    }
    
}

enum PhotoOptions {
    
    case SelectPhoto
    case ViewPhoto
    
    static func getSelection(type : String) -> PhotoOptions {
        
        switch type {
            
        case "Select Photo" : return .SelectPhoto
        case "View Photo" : return .ViewPhoto
        default : break
        }
        
        return .SelectPhoto
    }
    
}
