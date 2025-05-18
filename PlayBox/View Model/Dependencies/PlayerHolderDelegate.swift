//
//  PlayerHolderDelegate.swift
//  PlayBox
//
//  Created by Thejas on 14/03/25.
//

import UIKit

protocol PlayerHolderDelegate where Self : UIViewController {
    func showThumbnail()
    func closePlayer()
    func loadNext()
    func loadPrevious()
    
}
