//
//  DetailsHolderView.swift
//  PlayBox
//
//  Created by Thejas on 26/03/25.
//

import Foundation
import UIKit

class DetailsHolderView : UIView , DetailsHolderProtocol {
    
    var builder: (any DetailsHolderUIComponentBuilderDependency)?
    
    var components : [DetailsPageUIComponents]?
    
    var scrollView: UIScrollView?
    
    var collection: UICollectionView?
    
    var collectionTitle : UILabel?
    
    var title: UILabel?
    
    var maturityRating: UILabel?
    
    var duration: UILabel?
    
    var contentDescription: UILabel?
    
    var playButton: UIButton?
    
    var download: UIButton?
    
    var expandButton : UIButton?
    
    weak var detailHolderDelegate : DetailsHolderDelegate?
    
    private var relatedItems : [VideoItem]? {
        
        didSet {
            DispatchQueue.main.async {
                self.collection?.reloadData()
            }
        }
        
    }
    
    @IBOutlet weak var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        addSubview(view)
        
        self.backgroundColor = .clear
        view.backgroundColor = .clear
        
        setupView()
    }
    
    private func loadViewFromNib() -> UIView {
        
        let nib = UINib(nibName: "DetailsHolderView", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self)[0] as! UIView
        
    }
    
    private func setupView() {
        
        setupScrollView()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func setupScrollView() {
        
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView!)
        
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        
        scrollView?.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        scrollView?.clipsToBounds = true
        scrollView?.layer.cornerRadius = 4.0
        
        scrollView?.contentSize = CGSize(width: view.bounds.width , height: view.bounds.height + 100)
        
    }
    
    func setupItem(item : VideoItem) {
        
        DispatchQueue.main.async {
            self.title?.text = item.title
            self.maturityRating?.text = "U/A"
            self.duration?.text = "00h : 00m"
            self.contentDescription?.text = item.description
        }
        
    }
    
    func setupRelatedItems(items : [VideoItem]) {
        relatedItems = items
    }
    
    func setupBuilder(builder : DetailsHolderUIComponentBuilderDependency) {
        
        self.builder = builder
        
        setupComponents()
    }
    
    func setupComponents() {
        
        let titleStyling = PlayBoxLabelStyling()
        let maturityRatingStyling = PlayBoxLabelStyling()
        let durationStyling = PlayBoxLabelStyling()
        let descriptionStyling = PlayBoxLabelStyling()
        let collectionTitleStyling = PlayBoxLabelStyling()
        let playButtonStyling = PlayBoxButtonStyling()
        let downloadButtonStyling = PlayBoxButtonStyling()
        let expandButtonStyling = PlayBoxButtonStyling()
        
        components = [DetailsPageUIComponents]()
        components?.append(.Title(labelDependency: titleStyling))
        components?.append(.MaturityRating(labelDependency: maturityRatingStyling))
        components?.append(.Duration(labelDependency: durationStyling))
        components?.append(.ContentDescription(labelDependency: descriptionStyling))
        components?.append(.ExpandButton(expandButtonStyling))
        components?.append(.PlayButton(playButtonStyling))
        components?.append(.DownloadButton(downloadButtonStyling))
        components?.append(.CollectionTitle(labelDependency: collectionTitleStyling))
        components?.append(.Collection(scrollDirection: .horizontal))
        
        buildUIComponents()
    }
    
    func buildUIComponents() {
        
        guard let builder = builder else {return}
        
        guard let components = components else {return}
        
        for component in components {
            
            switch component {
            case .Collection(let scrollDirection):
                guard let collection = builder.getComponentOf(type: .Collection(scrollDirection: scrollDirection)) as? UICollectionView else {return}
                
                setupCollection(collection: collection)
                
            case .CollectionTitle(let labelDependency):
                
                guard let collectionTitle = builder.getComponentOf(type: .CollectionTitle(labelDependency: labelDependency)) as? UILabel else {return}
                
                setupCollectionTitle(label: collectionTitle)
                
            case .Title(let labelDependency):
                
                guard let label = builder.getComponentOf(type: .Title(labelDependency: labelDependency)) as? UILabel else {return}
                
                setupTitle(titleLabel: label)
                
            case .MaturityRating(let labelDependency):
                
                guard let label = builder.getComponentOf(type: .MaturityRating(labelDependency: labelDependency)) as? UILabel else {return}
                
                setupMaturityConsent(label: label)
                
            case .Duration(let labelDependency):
                
                guard let label = builder.getComponentOf(type: .Duration(labelDependency: labelDependency)) as? UILabel else {return}
                
                setupDuration(label: label)
                
            case .ContentDescription(let labelDependency):
                
                guard let label = builder.getComponentOf(type: .ContentDescription(labelDependency: labelDependency)) as? UILabel else {return}
                
                setupDescription(label: label)
                
            case .PlayButton(let buttonStylingDependency):
                
                guard let button = builder.getComponentOf(type: .PlayButton(buttonStylingDependency)) as? UIButton else {return}
                
                setupPlayButton(button: button)
                
            case .DownloadButton(let buttonStylingDependency):
                
                guard let button = builder.getComponentOf(type: .DownloadButton(buttonStylingDependency)) as? UIButton else {return}
                
                setupDownloadButton(button: button)
                
            case .ExpandButton(let buttonStylingDependency):
                
                guard let button = builder.getComponentOf(type: .ExpandButton(buttonStylingDependency)) as? UIButton else {return}
                
                setupExpandButton(button: button)
            }
            
        }
        
    }
    
    private func setupTitle(titleLabel:UILabel) {
        
        guard let scrollHolder = self.scrollView else {return}
        
        scrollHolder.addSubview(titleLabel)
        
        self.title = titleLabel
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        titleLabel.leadingAnchor.constraint(equalTo: scrollHolder.leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollHolder.topAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width * 0.1).isActive = true
        
    }
    
    private func setupMaturityConsent(label:UILabel) {
        
        guard let scrollHolder = self.scrollView , let title = self.title else {return}
        
        scrollHolder.addSubview(label)
        
        self.maturityRating = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: scrollHolder.leadingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
    }
    
    private func setupDuration(label:UILabel) {
        
        guard let scrollHolder = self.scrollView , let title = self.title , let maturityRating = self.maturityRating else {return}
        
        scrollHolder.addSubview(label)
        
        self.duration = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: maturityRating.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
    }
    
    private func setupDescription(label:UILabel) {
        
        guard let scrollHolder = self.scrollView , let duration = self.duration else {return}
        
        scrollHolder.addSubview(label)
        
        self.contentDescription = label
        
        label.numberOfLines = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: scrollHolder.leadingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: duration.bottomAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.height * 0.2).isActive = true
        
    }
    
    private func setupPlayButton(button:UIButton) {
        
        guard let scrollHolder = self.scrollView , let expand = expandButton else {return}
        
        scrollHolder.addSubview(button)
        
        self.playButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: scrollHolder.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: expand.bottomAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.75).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.15).isActive = true
        
        button.configuration = .plain()
        
    }
    
    private func setupDownloadButton(button:UIButton) {
        
        guard let scrollHolder = self.scrollView , let playButton = playButton else {return}
        
        scrollHolder.addSubview(button)
        
        self.download = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: scrollHolder.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.75).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.15).isActive = true
        
        button.configuration = .plain()
        
    }
    
    private func setupExpandButton(button:UIButton) {
        
        guard let scrollHolder = self.scrollView , let contentDescription = contentDescription else {return}
        
        scrollHolder.addSubview(button)
        
        self.expandButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        button.topAnchor.constraint(equalTo: contentDescription.bottomAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        button.contentMode = .center
        
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupCollectionTitle(label:UILabel) {
        
        guard let scrollHolder = self.scrollView , let download = self.download else {return}
        
        scrollHolder.addSubview(label)
        
        self.collectionTitle = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: download.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: scrollHolder.leadingAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
        label.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.1).isActive = true
        
    }
    
    private func setupCollection(collection:UICollectionView) {
        
        guard let scrollHolder = self.scrollView , let collectionTitle = collectionTitle else {return}
        
        scrollHolder.addSubview(collection)
        
        self.collection = collection
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.backgroundColor = .clear
        
        collection.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor, constant: 10).isActive = true
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
        collection.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        //collection.register(CatalogImageCVCell.classForCoder(), forCellWithReuseIdentifier: CatalogImageCVCell.getCellIdentifier())
        
        collection.register(UINib(nibName: CatalogImageCVCell.getNibName(), bundle: Bundle(for: CatalogImageCVCell.classForCoder())), forCellWithReuseIdentifier: CatalogImageCVCell.getCellIdentifier())
        
    }
    
    @objc func expandButtonTapped() {
        
        
        
        scrollView?.contentSize = CGSize(width: view.bounds.width , height: view.bounds.height + 100)
        
    }
    
    private func getContentSize() -> CGSize {
        
        guard let components = components else {return .zero}
        
        
        
        return .zero
    }
    
}

extension DetailsHolderView : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        relatedItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogImageCVCell.getCellIdentifier(), for: indexPath) as? CatalogImageCVCell else {return UICollectionViewCell()}
        
        guard let item = relatedItems?[indexPath.row] else {return cell}
        
        cell.setupCell(item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        detailHolderDelegate?.cellSize() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }
    
}
