//
//  HomeCarouselTableViewCell.swift
//  PlayBox
//
//  Created by Thejas on 25/01/25.
//

import Foundation
import UIKit

class HomeCarouselTableViewCell : UITableViewCell {
    
    class func getCellIdentifier() -> String {
        "HomeCarouselTableViewCell"
    }
    
    class func getNibName() -> String {
        "HomeCarouselTableViewCell"
    }
    
    @IBOutlet weak var carouselCollection: UICollectionView!
    
    @IBOutlet weak var titleSwipeButton: UIButton!
    
    @IBOutlet weak var itemIndicator: CustomPageControl!
    
    private var timer : Timer?
    private var rightSwipe : UISwipeGestureRecognizer?
    private var leftSwipe : UISwipeGestureRecognizer?
    
    var items : [VideoItem]? {
        
        didSet {
            carouselCollection?.reloadData()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        carouselCollection?.delegate = self
        carouselCollection?.dataSource = self
        registerCells()
        
        itemIndicator.allowsContinuousInteraction = true
        itemIndicator.direction = .leftToRight
        carouselCollection.showsHorizontalScrollIndicator = false
        carouselCollection.isScrollEnabled = false
        
        setupTitleSwipeButton()
        
    }
    
    func setupCell(items:[VideoItem]) {
        
        if self.items == nil {
            self.items = items
        }
        
        setupItems()
    }
    
    func setupTitleSwipeButton() {
        
        let font = FontType.BungeeShader
        titleSwipeButton.titleLabel?.font = font.getFont()
        titleSwipeButton.titleLabel?.numberOfLines = 0
        titleSwipeButton.titleLabel?.textAlignment = .center
        titleSwipeButton.setTitleColor(font.color, for: .normal)
        
        guard rightSwipe == nil else {return}
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(updateItem(_:)))
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(updateItem(_:)))
        leftSwipe?.direction = .left
        
        rightSwipe?.delegate = self
        leftSwipe?.delegate = self
        
        titleSwipeButton.addGestureRecognizer(rightSwipe!)
        titleSwipeButton.addGestureRecognizer(leftSwipe!)
    }
    
    @objc func updateItem(_ sender : UISwipeGestureRecognizer) {
        
        timer?.invalidate()
        
        guard let count = items?.count else {return}
        
        if sender.direction == .left {
            
            if itemIndicator.currentPage == count - 1 {
                if let title = items?[0].title {
                    slideButtonTitle(button: titleSwipeButton, newTitle: title, direction: .left)
                    
                    itemIndicator.currentPage = 0
                }
            }
            else {
                if let title = items?[itemIndicator.currentPage + 1].title {
                    slideButtonTitle(button: titleSwipeButton, newTitle: title, direction: .left)
                    
                    itemIndicator.currentPage = itemIndicator.currentPage + 1
                }
            }
            
        }
        else if sender.direction == .right {
            
            if itemIndicator.currentPage == 0 {
                if let title = items?[count - 1].title {
                    slideButtonTitle(button: titleSwipeButton, newTitle: title, direction: .right)
                    
                    self.itemIndicator.currentPage = count - 1
                    
                }
            }
            else {
                if let title = items?[itemIndicator.currentPage - 1].title {
                    slideButtonTitle(button: titleSwipeButton, newTitle: title, direction: .right)
                    
                    itemIndicator.currentPage -= 1
                }
            }
            
        }
        
        carouselCollection.scrollToItem(at: IndexPath(row: itemIndicator.currentPage, section: 0),at: .centeredHorizontally,animated: false)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            self?.updateItem()
        }
        
    }
    
    func setupItems() {
        
        guard timer == nil else { return }
        
        timer?.invalidate()
        timer = nil
        
        if let itemCount = items?.count {
            itemIndicator.numberOfPages = itemCount
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            self?.updateItem()
        }
    }

    @objc func updateItem() {

        guard let items = items, !items.isEmpty else { return }
        let itemCount = items.count
        
        let currentPage = itemIndicator.currentPage
        
        let nextPage = (currentPage == itemCount - 1) ? 0 : currentPage + 1
        
        let font = FontSelector.shared.getFontFor(index: nextPage)
        
        titleSwipeButton.setTitle(items[nextPage].title, for: .normal)
        titleSwipeButton.titleLabel?.font = font.getFont()
        titleSwipeButton.setTitleColor(font.color, for: .normal)
        
        carouselCollection.scrollToItem(at: IndexPath(row: nextPage, section: 0),at: .centeredHorizontally,animated: false)
        
        itemIndicator.currentPage = nextPage
    }

    func registerCells() {
        carouselCollection?.register(UINib(nibName: BaseImageCollectionCell.getNibName(), bundle: Bundle(for: BaseImageCollectionCell.classForCoder())), forCellWithReuseIdentifier: BaseImageCollectionCell.getCellIdentifier())
    }
    
    func slideButtonTitle(button: UIButton, newTitle: String , direction : ButtonSwipeDirection) {
        
        if direction == .right {
            
            UIView.animate(withDuration: 0.2, animations: {
                button.alpha = 0
                button.transform = CGAffineTransform(translationX: button.bounds.width, y: 0)
                
            }) { _ in
                
                button.setTitle(newTitle, for: .normal)
                
                button.transform = .identity
                
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 1
                    let font = FontSelector.shared.getFontFor(index: self.itemIndicator.currentPage)
                    button.titleLabel?.font = font.getFont()
                    button.setTitleColor(font.color, for: .normal)
                }
            }
        }
        else {
            
            UIView.animate(withDuration: 0.2, animations: {
                button.alpha = 0
                button.transform = CGAffineTransform(translationX: 0 - button.bounds.width, y: 0)
                
            }) { _ in
                
                button.setTitle(newTitle, for: .normal)
                
                button.transform = .identity
                
                UIView.animate(withDuration: 0.1) {
                    
                    button.alpha = 1
                    let font = FontSelector.shared.getFontFor(index: self.itemIndicator.currentPage)
                    button.titleLabel?.font = font.getFont()
                    button.setTitleColor(font.color, for: .normal)
                }
            }
            
        }
        
        
        
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
}

extension HomeCarouselTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseImageCollectionCell.getCellIdentifier(), for: indexPath) as? BaseImageCollectionCell else {return UICollectionViewCell()}
        
        if let item = items?[indexPath.row] {
            cell.setupCell(item: item)
            
            self.titleSwipeButton?.setTitle(item.title, for: .normal)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
    
}

enum ButtonSwipeDirection {
    case left
    case right
}

//extension HomeCarouselTableViewCell {
//    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        titleSwipeButton.setTitle("", for: .normal)
//        return true
//    }
//    
//}
