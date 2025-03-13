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
    
}

protocol ContentDetailsViewUpdateDelegate : AnyObject {
    
    func updateImage(image : UIImage?)
    
}
