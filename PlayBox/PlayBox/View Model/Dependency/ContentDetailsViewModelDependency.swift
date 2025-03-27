//
//  ContentDetailsViewModelDependency.swift
//  PlayBox
//
//  Created by Thejas on 09/03/25.
//

import Foundation
import UIKit

protocol ContentDetailsViewModelDependency : AnyObject {
    
    func loadImage()
    func getRelatedItems() 
    
}

protocol ContentDetailsViewUpdateDelegate : AnyObject {
    
    func updateImage(image : UIImage?)
    func updateLoader(isLoading : Bool)
    func updateRelated(items : [VideoItem])
    
}
