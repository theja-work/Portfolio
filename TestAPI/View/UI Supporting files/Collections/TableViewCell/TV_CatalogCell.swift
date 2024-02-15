//
//  TV_CatalogCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 15/02/24.
//

import Foundation
import UIKit

class TV_CatalogCell : UITableViewCell {
    
    public class func getNibName() -> String {
        return "TV_CatalogCell"
    }
    
    public class func getCellIdentifier() -> String {
        return "TV_CatalogCell"
    }
    
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var openListButton:UIButton!
    
    @IBOutlet weak var contentCollectionView:UICollectionView!
    
    weak var contentSelectionDelegate : ContentSelectionProtocol?
    
    var videos : [VideoItem]? {
        
        didSet {
            
            contentCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        
    }
    
    public func setupCell(item:VideoItem,indexPath:IndexPath,contentSelectionDelegate:ContentSelectionProtocol) {
        registerCollectionViewCells()
        
        self.contentSelectionDelegate = contentSelectionDelegate
        
        if indexPath.row % 2 == 0 {
            titleLabel.text = "Popular"
        }
        else {
            titleLabel.text = "New Releases"
        }
        
        titleLabel.font = CustomFont.Roboto_Medium.font
        
    }
    
    func registerCollectionViewCells() {
        
        contentCollectionView.register(UINib(nibName: HomePageCatalogCollectionViewCell.nibName(), bundle: Bundle(for: HomePageCatalogCollectionViewCell.classForCoder())), forCellWithReuseIdentifier: HomePageCatalogCollectionViewCell.cellIdentifier())
        contentCollectionView.backgroundColor = .clear
        
    }
    
}

extension TV_CatalogCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let item = self.videos?[indexPath.row] else {return UICollectionViewCell()}
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePageCatalogCollectionViewCell.cellIdentifier(), for: indexPath) as? HomePageCatalogCollectionViewCell
        
        cell?.setupCell(item: item, indexPath: indexPath)
        
        return cell ?? UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = videos?[indexPath.row] else {return}
        
        contentSelectionDelegate?.contentSelected(item: item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 101.0, height: 143)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//    }
    
}
