//
//  HomeViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var catalogTableView: UITableView!
    
    private var viewModel : VideoViewModel?
    private var loader : Loader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getVideoData()
    }
    
    func setupLoader() {
        loader = Loader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        loader?.addLoader(view: self.view)
    }
    
    func setupTableView() {
        registerCells()
        setupLoader()
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
                    cell.setupCell(items: videos)
                }
            }
            
            return cell
            
        }
        
        guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: HomeCatalogTableViewCell.getCellIdentifier()) as? HomeCatalogTableViewCell else {return UITableViewCell()}
        
        DispatchQueue.main.async {
            
            if let videos = self.viewModel?.catalogItems {
                cell.setupCell(videos: videos, catalogName: "Sample titles")
            }
        }
        
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
            AppUtilities.shared.log("Server error with code : \(code) : message : \(message)")
        case .parsingError(let code, let message):
            AppUtilities.shared.log("Parsing error with code : \(code) : message : \(message)")
        case .dataNotFound:
            AppUtilities.shared.log("dataNotFound")
        case .networkError:
            AppUtilities.shared.log("networkError")
        case .unkownError:
            AppUtilities.shared.log("unkownError")
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
