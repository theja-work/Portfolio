//
//  TV_BannerCell.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 15/02/24.
//

import Foundation
import UIKit

class TV_BannerCell : UITableViewCell {
    
    @IBOutlet weak var carouselHolderView: UIView!
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControlView: UIPageControl!
    
    var contentSelectionDelegate:ContentSelectionProtocol?
    
    var timer : Timer?
    
    var currentIndex : Int = 0
    
    var count : Int = 0
    
    var videos : [VideoItem]? {
        
        didSet {
            if let count = videos?.count {
                self.count = count
            }
            carouselCollectionView.reloadData()
        }
    }
    
    public class func getNibName() -> String {
        return "TV_BannerCell"
    }
    
    public class func getCellIdentifier() -> String {
        return "TV_BannerCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        
        addTimer()
    }
    
    public func setupCell(item:VideoItem,indexPath:IndexPath,contentSelectionDelegate:ContentSelectionProtocol) {
        registerCollectionViewCells()
        
        self.contentSelectionDelegate = contentSelectionDelegate
        
        if let count = self.videos?.count {
            pageControlView.numberOfPages = count
        }
        
    }
    
    func addTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(scrollNext), userInfo: nil, repeats: true)
        
    }
    
    @objc func scrollNext(){
        
        if(currentIndex < count - 1){
            currentIndex = currentIndex + 1;
            
        }else if (currentIndex == count - 1){
            currentIndex = 0;
        }
        
        carouselCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func registerCollectionViewCells() {
        
        carouselCollectionView.register(UINib(nibName: HomepageCollectionViewCell.nibName(), bundle: Bundle(for: HomepageCollectionViewCell.classForCoder())), forCellWithReuseIdentifier: HomepageCollectionViewCell.cellIdentifier())
        
    }
    
}

extension TV_BannerCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.pageControlView.currentPage = Int(indexPath.row)
        guard let item = self.videos?[indexPath.row] else {return UICollectionViewCell()}
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomepageCollectionViewCell.cellIdentifier(), for: indexPath) as? HomepageCollectionViewCell
        
        guard let selectionDelegate = self.contentSelectionDelegate else {return UICollectionViewCell()}
        
        cell?.setupCell(item: item, indexPath: indexPath)
        return cell ?? UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 186)
    }
    
    
}
