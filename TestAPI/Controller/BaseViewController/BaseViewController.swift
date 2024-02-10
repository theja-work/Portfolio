//
//  BaseViewController.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 10/02/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

public class BaseViewController : UIViewController {
    
    var loader : Loader?
    var toast : Toast?
    
    public override func viewDidLoad() {
        loader = Loader(view: self.view)
        toast = Toast()
    }
}
