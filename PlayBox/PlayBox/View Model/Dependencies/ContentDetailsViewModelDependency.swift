//
//  ContentDetailsViewModelDependency.swift
//  PlayBox
//
//  Created by Thejas on 09/03/25.
//

import Foundation
import UIKit

protocol ContentDetailsViewModelDependency : AnyObject {
    
    func getRelatedItems()
    
}

protocol ContentDetailsViewUpdateDelegate : AnyObject {
    
    func updateLoader(isLoading : Bool)
    func updateRelated(items : [VideoItem])
    
}
