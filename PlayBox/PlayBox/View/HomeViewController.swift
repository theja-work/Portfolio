//
//  HomeViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit
import Combine

class HomeViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var catalogTableView: UITableView!
    
    var cancellables : Set<AnyCancellable> = []
    var viewModel : VideoViewModel?
    var videos : [VideoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGreen
        
        registerCells()
        setupViewModel()
        setupObservers()
        getVideoData()
        
        let loader = Loader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        loader.addLoader(view: self.view)
        
        loader.showLoader()
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
            loader.stopAnimating()
        }
        
    }
    
    func setupTableView() {
        
    }
    
    func registerCells() {
        
        catalogTableView.showsVerticalScrollIndicator = false
        catalogTableView?.register(UINib(nibName: HomeCarouselTableViewCell.getNibName(), bundle: Bundle(for: HomeCarouselTableViewCell.classForCoder())), forCellReuseIdentifier: HomeCarouselTableViewCell.getCellIdentifier())
        catalogTableView?.register(UINib(nibName: HomeCatalogTableViewCell.getNibName(), bundle: Bundle(for: HomeCatalogTableViewCell.classForCoder())), forCellReuseIdentifier: HomeCatalogTableViewCell.getCellIdentifier())
        
    }
    
    func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoListService())
        
    }
    
    func getVideoData() {
        
        self.viewModel?.getDataFromServer()
        
    }
    
    func setupObservers() {
        
        self.viewModel?.$videoResponse
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] response in
            
                guard let strongSelf = self else {return}
                
                switch response {
                    
                case .success(let videos) :
                    
                    strongSelf.printVideos(videos: videos)
                    strongSelf.videos = videos
                    strongSelf.catalogTableView?.reloadData()
                    
                case .serverError(let code, let message) :
                    
                    print("serverError : \(code) : \(message)")
                    
                case .parsingError(let code, let message) :
                    
                    print("parsingError : \(code) : \(message)")
                    
                default : break
                    
                }
            }).store(in: &cancellables)
        
    }
    
    func printVideos(videos : [VideoModel]) {
        
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
        
        videos?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: HomeCarouselTableViewCell.getCellIdentifier()) as? HomeCarouselTableViewCell else {return UITableViewCell()}
            
            if let videos = self.videos {
                cell.setupCell(items: videos)
            }
            
            return cell
            
        }
        
        guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: HomeCatalogTableViewCell.getCellIdentifier()) as? HomeCatalogTableViewCell else {return UITableViewCell()}
        
        DispatchQueue.main.async {
            if let video = self.videos?[indexPath.row] {
                cell.setupCell(video: video)
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
    
}
