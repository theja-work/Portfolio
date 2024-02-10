//
//  Toast.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 10/02/24.
//

import Foundation
import UIKit

public class Toast {
    
    public init(){}
    
    public func showToast(controller:BaseViewController,text:String,seconds:Double) {
        
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            alert.dismiss(animated: true)
        })
    }
    
}
