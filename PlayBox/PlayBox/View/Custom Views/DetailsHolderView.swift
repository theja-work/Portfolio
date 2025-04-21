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
    
    var stackView : UIStackView?
    
    var durationLabelStack = {
        
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 8.0
        stack.backgroundColor = .clear
        
        return stack
    }()
    
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
    
    let titleStyling = PlayBoxLabelStyling()
    let maturityRatingStyling = PlayBoxLabelStyling()
    let durationStyling = PlayBoxLabelStyling()
    let descriptionStyling = PlayBoxLabelStyling()
    let collectionTitleStyling = PlayBoxLabelStyling()
    let playButtonStyling = PlayBoxButtonStyling()
    let downloadButtonStyling = PlayBoxButtonStyling()
    let expandButtonStyling = PlayBoxButtonStyling()
    
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
        
        setupScrollView()
        
        setupBuilder(builder: DetailsHolderComponentBuilder())
        
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
        scrollView?.scrollsToTop = true
        
        scrollView?.contentSize = CGSize(width: view?.bounds.width ?? 0, height: view?.bounds.height ?? 0)
        
        setupStackView()
    }
    
    private func setupStackView() {
        
        guard let scrollView = scrollView else {return}
        
        stackView = UIStackView(frame: .zero)
        
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView!)
        
        stackView?.axis = .vertical
        stackView?.spacing = 12
        stackView?.alignment = .fill
        stackView?.distribution = .fill
        stackView?.backgroundColor = .clear
        
        stackView?.topAnchor.constraint(equalTo: scrollView.topAnchor , constant: 5).isActive = true
        stackView?.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor , constant: -5).isActive = true
        stackView?.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.95).isActive = true
        stackView?.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupItem(item : VideoItem) {
        
        DispatchQueue.main.async {
            self.title?.text = item.title
            self.maturityRating?.text = "U/A"
            self.duration?.text = self.detailHolderDelegate?.getDuration() ?? "00h : 00m"
            self.contentDescription?.text = item.description
        }
        
    }
    
    func setupRelatedItems(items : [VideoItem]) {
        relatedItems = items
    }
    
    func setupBuilder(builder : DetailsHolderUIComponentBuilderDependency) {
        
        self.builder = builder
        
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
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(titleLabel)
        
        self.title = titleLabel
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
    }
    
    private func setupMaturityConsent(label:UILabel) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(durationLabelStack)
        durationLabelStack.addArrangedSubview(label)
        
        self.maturityRating = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabelStack.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        
    }
    
    private func setupDuration(label:UILabel) {
        
        durationLabelStack.addArrangedSubview(label)
        
        self.duration = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        
    }
    
    private func setupDescription(label:UILabel) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(label)
        
        self.contentDescription = label
        
        label.numberOfLines = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.height * 0.2).isActive = true
        
        holder.setCustomSpacing(5, after: label)
    }
    
    private func setupExpandButton(button:UIButton) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(button)
        
        self.expandButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        button.contentMode = .center
        
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupPlayButton(button:UIButton) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(button)
        
        self.playButton = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        
        button.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.15).isActive = true
        
        button.configuration = .plain()
        
    }
    
    private func setupDownloadButton(button:UIButton) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(button)
        
        self.download = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.15).isActive = true
        
        button.configuration = .plain()
        
    }
    
    private func setupCollectionTitle(label:UILabel) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(label)
        
        self.collectionTitle = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.1).isActive = true
        
    }
    
    private func setupCollection(collection:UICollectionView) {
        
        guard let holder = self.stackView else {return}
        
        holder.addArrangedSubview(collection)
        
        self.collection = collection
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        
        collection.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        collection.register(UINib(nibName: CatalogImageCVCell.getNibName(), bundle: Bundle(for: CatalogImageCVCell.classForCoder())), forCellWithReuseIdentifier: CatalogImageCVCell.getCellIdentifier())
        
    }
    
    @objc func playButtonAction(sender button : UIButton) {
        
        let title = detailHolderDelegate?.isPlaying() ?? false ? "Play" : "Pause"
        
        DispatchQueue.main.async {
            button.setTitle(title, for: .normal)
        }
        
        detailHolderDelegate?.isPlaying() ?? false ? pause() : play()
        
    }
    
    private func play() {
        detailHolderDelegate?.play()
    }
    
    private func pause() {
        detailHolderDelegate?.pause()
    }
    
    private func startDownload() {
        
    }
    
    @objc func expandButtonTapped() {
        guard let contentDescription = contentDescription else { return }
        
        UIView.performWithoutAnimation {
            contentDescription.numberOfLines = (contentDescription.numberOfLines == 3) ? 0 : 3
            expandButton?.setImage(UIImage(named: contentDescription.numberOfLines == 3 ? "down" : "up"), for: .normal)
            
            
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = relatedItems?[indexPath.row] else {return}
        
        detailHolderDelegate?.didSelect(item: item)
        setupItem(item: item)
        
    }
    
}
