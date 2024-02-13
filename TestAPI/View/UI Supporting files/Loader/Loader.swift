//
//  Loader.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 10/02/24.
//

import Foundation
import NVActivityIndicatorView
import UIKit

public class Loader {
    
    var loaderView : NVActivityIndicatorView?
    
    public init(view:UIView){
        
        loaderView?.backgroundColor = UIColor.clear
        loaderView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        view.addSubview(loaderView!)
        view.bringSubviewToFront(loaderView!)
        loaderView?.center = view.center
        self.loaderView?.isHidden = true
        
        setupLoader()
        //loaderView?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
    
    public func setupLoader() {
        if loaderView == nil {return}
        
        loaderView?.type = .lineScale
        loaderView?.color = ColorCodes.turmeric.color
    }
    
    public func showLoader() {
        if loaderView == nil {return}
        
        if loaderView?.isHidden == true {
            loaderView?.isHidden = false
        }
        
        DispatchQueue.main.async {
            self.loaderView?.startAnimating()
        }
    }
    
    public func hideLoader() {
        if loaderView == nil {return}
        
        loaderView?.isHidden = true
        DispatchQueue.main.async {
            self.loaderView?.stopAnimating()
        }
    }
}
