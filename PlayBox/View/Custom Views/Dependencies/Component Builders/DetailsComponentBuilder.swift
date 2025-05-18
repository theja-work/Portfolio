//
//  DetailsComponentBuilder.swift
//  PlayBox
//
//  Created by Thejas on 28/03/25.
//

import UIKit

class DetailsHolderComponentBuilder : DetailsHolderUIComponentBuilderDependency {
    
    func getComponentOf(type : DetailsPageUIComponents) -> UIView? {
        
        switch type {
        case .Collection(let scrollDirection):
            
            guard let direction = scrollDirection else {return nil}
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = direction
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
            
        case .CollectionTitle(let labelDependency):
            
            guard let dependency = labelDependency as? PlayBoxLabelStyling else {return nil}
            
            guard let font = UIFont(name: "KeaniaOne-Regular", size: 20) else {return nil}
            
            let color = UIColor.systemYellow.withAlphaComponent(0.8)
            
            dependency.buildStyling(title: "Related Videos", font: font, textColor: color, backGroundColor: .clear, cornerRadius: nil)
            
            return getLabel(from: dependency)
            
        case .Title(let labelDependency):
            
            guard let dependency = labelDependency as? PlayBoxLabelStyling else {return nil}
            
            guard let font = UIFont(name: "BungeeTint-Regular", size: 26) else {return nil}
            
            dependency.buildStyling(title: "Sample title", font: font, textColor: .red, backGroundColor: .clear, cornerRadius: nil)
            
            return getLabel(from: dependency)
            
        case .MaturityRating(let labelDependency):
            
            guard let dependency = labelDependency as? PlayBoxLabelStyling else {return nil}
            
            dependency.buildStyling(title: "", font: .systemFont(ofSize: 16), textColor: .lightGray, backGroundColor: .clear, cornerRadius: nil)
            
            return getLabel(from: dependency)
            
        case .Duration(let labelDependency):
            
            guard let dependency = labelDependency as? PlayBoxLabelStyling else {return nil}
            
            dependency.buildStyling(title: "", font: .systemFont(ofSize: 16), textColor: .black, backGroundColor: .lightGray, cornerRadius: 3.0)
            
            let label = getLabel(from: dependency)
            
            label.textAlignment = .center
            
            return label
            
        case .ContentDescription(let labelDependency):
            
            guard let dependency = labelDependency as? PlayBoxLabelStyling else {return nil}
            
            dependency.buildStyling(title: "", font: .systemFont(ofSize: 16), textColor: .systemYellow.withAlphaComponent(0.6), backGroundColor: .clear, cornerRadius: nil)
            
            return getLabel(from: dependency)
            
        case .PlayButton(let buttonStylingDependency):
            
            guard let buttonDep = buttonStylingDependency as? PlayBoxButtonStyling else {return nil}
            
            guard let font = UIFont(name: "KeaniaOne-Regular", size: 20) else {return nil}
            
            buttonDep.buildStyling(title: "Play", font: font, image: nil, textColor: .white, backgroundColor: .black, cornerRadius: 8.0)
            
            return getButton(from: buttonDep)
            
        case .DownloadButton(let buttonStylingDependency):
            
            guard let buttonDep = buttonStylingDependency as? PlayBoxButtonStyling else {return nil}
            
            guard let font = UIFont(name: "KeaniaOne-Regular", size: 20) else {return nil}
            
            buttonDep.buildStyling(title: "Download", font: font, image: nil, textColor: .black, backgroundColor: .white, cornerRadius: 8.0)
            
            return getButton(from: buttonDep)
            
        case .ExpandButton(let buttonStylingDependency):
            
            guard let buttonDep = buttonStylingDependency as? PlayBoxButtonStyling else {return nil}
            
            buttonDep.buildStyling(title: "", font: UIFont(), image: UIImage(named: "down"), textColor: .clear, backgroundColor: .clear, cornerRadius: 0.0)
            
            let button = getButton(from: buttonDep)
            
            button.tintColor = UIColor.systemYellow.withAlphaComponent(0.8)
            
            return button
        }
        
    }
    
    func getLabel(from dependency: PlayBoxLabelStyling) -> UILabel {
        
        let label = UILabel(frame: .zero)
        
        dependency.setupLabel(label: label)
        
        return label
    }
    
    func getButton(from dependency: PlayBoxButtonStyling) -> UIButton {
        
        let button = UIButton(frame: .zero)
        
        dependency.setupButton(button: button)
        
        return button
        
    }
    
}
