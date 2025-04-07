//
//  DetailsUIComponentDependency.swift
//  PlayBox
//
//  Created by Thejas on 28/03/25.
//

import UIKit

protocol DetailsHolderUIComponentBuilderDependency : AnyObject {
    
    func getComponentOf(type : DetailsPageUIComponents) -> UIView?
    func getLabel(from dependency : PlayBoxLabelStyling) -> UILabel
    func getButton(from dependency : PlayBoxButtonStyling) -> UIButton
    
}


enum DetailsPageUIComponents {
    
    case Collection(scrollDirection:UICollectionView.ScrollDirection?)
    case CollectionTitle(labelDependency:(any LabelStylingDependency)?)
    case Title(labelDependency:(any LabelStylingDependency)?)
    case MaturityRating(labelDependency:(any LabelStylingDependency)?)
    case Duration(labelDependency:(any LabelStylingDependency)?)
    case ContentDescription(labelDependency:(any LabelStylingDependency)?)
    case PlayButton((any ButtonStylingDependency)?)
    case DownloadButton((any ButtonStylingDependency)?)
    case ExpandButton((any ButtonStylingDependency)?)
    
    var height : CGFloat {
        
        get {
            return 0
        }
        
        set {
            Logger.log(newValue)
        }
    }
    
    var name : String {
        
        switch self {
            
        case .Collection : return "Collection"
        case .CollectionTitle : return "Collection Title"
        case .Title : return "Title"
        case .MaturityRating : return "Maturity Rating"
        case .Duration : return "Duration"
        case .ContentDescription : return "Content Description"
        case .ExpandButton : return "Expand Button"
        case .PlayButton : return "Play Button"
        case .DownloadButton : return "Download"
            
        }
        
    }
    
}
