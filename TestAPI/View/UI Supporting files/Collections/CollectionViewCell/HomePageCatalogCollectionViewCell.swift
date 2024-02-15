//
//  HomePageCatalogCollectionViewCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 15/02/24.
//

import Foundation
import UIKit

class HomePageCatalogCollectionViewCell : UICollectionViewCell {
    
    public class func nibName() -> String {
        return "HomePageCatalogCollectionViewCell"
    }
    
    public class func cellIdentifier() -> String {
        return "HomePageCatalogCollectionViewCell"
    }
    
    @IBOutlet weak var contentCardImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(item:VideoItem,indexPath:IndexPath) {
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4.0
        
        self.contentCardImage.image = UIImage(named: "place_holder_4x3")
        self.contentCardImage.contentMode = .scaleToFill
        
        //setImageFrom(url: item.videoThumbnailUrl)
        
    }
    
    func setImageFrom(url:String) {
        
        if !StringHelper.isNilOrEmpty(string: url) {
            
            ImagePickerManager.getImageFromUrl(url: url) {[weak self] (imageResponse) in
                guard let localSelf = self else {return}
                
                switch imageResponse {
                case .success(let image):
                    DispatchQueue.main.async {
                        localSelf.contentCardImage.image = image
                    }
                    
                case .serverError(let error, let message):
                    print("server error with message : \(error) : \(message)")
                    
                default : break
                }
            }
            
        }
    }
    
}
