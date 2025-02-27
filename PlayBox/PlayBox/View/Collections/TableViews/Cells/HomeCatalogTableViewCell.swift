//
//  HomeCatalogTableViewCell.swift
//  PlayBox
//
//  Created by Thejas on 25/01/25.
//

import Foundation
import UIKit


class HomeCatalogTableViewCell : UITableViewCell {
    
    class func getCellIdentifier() -> String {
        "HomeCatalogTableViewCell"
    }
    
    class func getNibName() -> String {
        "HomeCatalogTableViewCell"
    }
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var catalogCollection: CustomCollectionView!
    
    private var items : [VideoItem]? {
        
        didSet {
            catalogCollection?.reloadData()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        catalogCollection?.delegate = self
        catalogCollection?.dataSource = self
        
        catalogCollection?.register(UINib(nibName: CatalogImageCVCell.getNibName(), bundle: Bundle(for: CatalogImageCVCell.classForCoder())), forCellWithReuseIdentifier: CatalogImageCVCell.getCellIdentifier())
        
        catalogCollection?.showsHorizontalScrollIndicator = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        catalogCollection?.collectionViewLayout = flowLayout
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleButton.setTitle("", for: .normal)
    }
    
    func setupCell(videos : [VideoItem] , catalogName : String) {
        
        if items == nil {
            items = videos
        }
        
        DispatchQueue.main.async {
            
            self.titleButton.setTitle(catalogName, for: .normal)
            self.titleButton.titleLabel?.textAlignment = .left
            self.titleButton.titleLabel?.contentMode = .left
            
            self.titleButton.setNeedsLayout()
            self.titleButton.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func titleAction(_ sender: UIButton) {
        print("Redirect to details page")
    }
    
}

extension HomeCatalogTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogImageCVCell.getCellIdentifier(), for: indexPath) as? CatalogImageCVCell else {return UICollectionViewCell()}
        
        if let item = items?[indexPath.row] {
            cell.setupCell(item: item)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.contentView.bounds.width * 0.3, height: self.bounds.height - titleButton.bounds.height)
        
    }
}
