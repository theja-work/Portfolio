//
//  CollectionViewCellDependency.swift
//  PlayBox
//
//  Created by Thejas on 04/04/25.
//

import UIKit

protocol CollectionViewCellDependency where Self : UICollectionViewCell {
    
    var imageGradient : CAGradientLayer? { get set }
    var item : VideoItem? { get set }
    var laoder : Loader? { get set }
    //static var imageCache : NSCache<NSString,UIImage> { get set }
    
}
