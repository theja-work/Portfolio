//
//  HomePageCollectionViewCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 15/02/24.
//

import Foundation
import UIKit

public class HomepageCollectionViewCell : UICollectionViewCell {
    
    public class func nibName() -> String {
        return "HomepageCollectionViewCell"
    }
    
    public class func cellIdentifier() -> String {
        return "HomepageCollectionViewCell"
    }
    
    @IBOutlet weak var imageView : UIImageView!
    
    @IBOutlet weak var playImage : UIImageView!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    public func setupCell(item:VideoItem,indexPath:IndexPath) {
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6.0
        
        if !StringHelper.isNilOrEmpty(string: item.videoTitle) {
            titleLabel.text = item.videoTitle
            titleLabel.font = CustomFont.Roboto_Regular.font
            titleLabel.textColor = .white
        }
        
        playImage.image = UIImage(named: "play_circle_button")
        imageView.image = UIImage(named: "place_holder_4x3")
        imageView.contentMode = .scaleToFill
        
        if indexPath.row != 3 {
            setImageFrom(url: item.videoThumbnailUrl)
        }
        
    }
    
    func setImageFrom(url:String) {
        if !StringHelper.isNilOrEmpty(string: url) {
            ImagePickerManager.getImageFromUrl(url: url) {[weak self] imageResponse in
                guard let localSelf = self else {return}
                
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async {
                        localSelf.imageView.image = image
                    }
                case .serverError(let error, let message):
                    print("server error with message : \(error) : \(message)")
                default : break
                }
            }
        }
    }
    
}
