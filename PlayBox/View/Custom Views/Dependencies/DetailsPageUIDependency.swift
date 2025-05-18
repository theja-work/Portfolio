//
//  DetailsPageUIDependency.swift
//  PlayBox
//
//  Created by Thejas on 28/03/25.
//

import UIKit

protocol DetailsHolderProtocol where Self : UIView {
    
    var builder : DetailsHolderUIComponentBuilderDependency? {get set}
    var detailHolderDelegate : DetailsHolderDelegate? {get set}
    var scrollView : UIScrollView? {get set}
    var stackView : UIStackView? {get set}
    
    var components : [DetailsPageUIComponents]? {get set}
    
    func setupBuilder(builder : DetailsHolderUIComponentBuilderDependency)
    
}

protocol DetailsHolderDelegate where Self : UIViewController {
    
    func didSelect(item : VideoItem)
    func scrollType() -> UICollectionView.ScrollDirection
    func cellSize() -> CGSize
    func play()
    func pause()
    func getDuration() -> String
    func startDownload()
    func pauseDownload()
    func deleteDownload()
    func isPlaying() -> Bool
    func isDownloading() -> Bool
    
}

