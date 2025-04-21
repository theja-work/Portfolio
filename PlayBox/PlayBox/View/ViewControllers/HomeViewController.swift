//
//  HomeViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    class func navigationController() -> UINavigationController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        guard let navigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController else {return nil}
        
        return navigationController
        
    }
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var catalogTableView: UITableView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    private var viewModel : VideoViewModel?
    private var loader : Loader?
    private var refreshData : UIRefreshControl?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(catalogTableView: UITableView!, viewModel: VideoViewModel? = nil, loader: Loader? = nil, refreshData: UIRefreshControl? = nil) {
        
        self.init(nibName: "Home", bundle: nil)
        
        self.catalogTableView = catalogTableView
        self.viewModel = viewModel
        self.loader = loader
        self.refreshData = refreshData
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setupTableView()
        setupViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        getVideoData()
    }
    
    func setBackgroundColor() {
        
        self.navigationItem.backButtonTitle = ""
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.systemBlue.cgColor , UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.type = .axial
        gradient.frame = self.view.bounds
        gradient.masksToBounds = true
        gradient.cornerRadius = 12
        DispatchQueue.main.async {
            self.view.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func setupLoader() {
        loader = Loader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        loader?.addLoader(to: self.view)
        loader?.shadeAffect = true
    }
    
    func setupTableView() {
        catalogTableView?.backgroundColor = .clear
        //catalogTableView.decelerationRate = .fast
        registerCells()
        setupLoader()
        setupRefreshMechanism()
    }
    
    func setupRefreshMechanism() {
        
        refreshData = UIRefreshControl()
        
        refreshData?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        
        catalogTableView.refreshControl = refreshData
        
    }
    
    @objc func refreshList() {
        getVideoData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.refreshData?.endRefreshing()
        }
    }
    
    func registerCells() {
        
        catalogTableView?.showsVerticalScrollIndicator = false
        catalogTableView?.register(UINib(nibName: HomeCarouselTableViewCell.getNibName(), bundle: Bundle(for: HomeCarouselTableViewCell.classForCoder())), forCellReuseIdentifier: HomeCarouselTableViewCell.getCellIdentifier())
        catalogTableView?.register(UINib(nibName: HomeCatalogTableViewCell.getNibName(), bundle: Bundle(for: HomeCatalogTableViewCell.classForCoder())), forCellReuseIdentifier: HomeCatalogTableViewCell.getCellIdentifier())
        
    }
    
    func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoListService(), videoUpdatesDelegate: self)
        
    }
    
    func getVideoData() {
        
        self.viewModel?.getDataFromServer()
        
    }
    
    func printVideos(videos : [VideoItem]) {
        
        for video in videos {
            print("id : \(video.id) :: video url : \(video.title)")
        }
        
    }
    
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        viewModel?.carouselItems?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: HomeCarouselTableViewCell.getCellIdentifier()) as? HomeCarouselTableViewCell else {return UITableViewCell()}
            
            DispatchQueue.main.async {
                if let videos = self.viewModel?.carouselItems {
                    cell.setupCell(items: videos, redirectionDelegate: self)
                }
            }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .black
            return cell
            
        }
        
        guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: HomeCatalogTableViewCell.getCellIdentifier()) as? HomeCatalogTableViewCell else {return UITableViewCell()}
        
        DispatchQueue.main.async {
            
            if let videos = self.viewModel?.catalogItems , let listName = self.viewModel?.catalogNames[indexPath.row] {
                cell.setupCell(videos: videos.shuffled(), catalogName: listName, catalogId: indexPath.row, redirectionDelegate: self)
            }
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 300.00
        }
        
        return 200.00
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //AppUtilities.shared.log("Add pagination logic")
    }
    
}

extension HomeViewController : VideoUpdatesProtocol {
    
    func updateUI(listType: VideoListType, response: Dataloader<[VideoItem]>) {
        
        switch response {
            
        case .success(let result):
            printVideos(videos: result)
        case .serverError(let code, let message):
            Logger.log("Server error with code : \(code) : message : \(message)")
        case .parsingError(let code, let message):
            Logger.log("Parsing error with code : \(code) : message : \(message)")
        case .dataNotFound:
            Logger.log("dataNotFound")
        case .networkError:
            Logger.log("networkError")
        case .unkownError:
            Logger.log("unkownError")
        }
        
    }
    
    func reloadList() {
        
        DispatchQueue.main.async {
            self.catalogTableView.reloadData()
        }
        
    }
    
    func updateLoader(isLoading: Bool) {
        
        DispatchQueue.main.async {
            isLoading ? self.loader?.showLoader() : self.loader?.hideLoader()
        }
        
    }
    
}

extension HomeViewController : ContentDetailsProtocol {
    
    func redirectToDetailsOf(item: VideoItem) {
        
        Logger.log(item.title)
        
        guard let detailsVC = ContentDetailsViewController.viewController(item: item) else {return}
        
        detailsVC.navigationController?.isNavigationBarHidden = true
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    
}
