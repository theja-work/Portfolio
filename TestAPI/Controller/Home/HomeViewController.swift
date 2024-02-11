//
//  HomeViewController.swift
//  TestAPI
//
//  Created by Thejas K on 06/08/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import NVActivityIndicatorView
import RxSwift
import RxCocoa

public class HomeViewController : BaseViewController {
    
    @IBOutlet weak var buttonHolder: UIView!
    
    @IBOutlet weak var profileButton: HomeButtons!
    
    @IBOutlet weak var imageButton: HomeButtons!
    
    @IBOutlet weak var audioButton: HomeButtons!
    
    @IBOutlet weak var videoButton: HomeButtons!
    
    @IBOutlet weak var videoListTableView: UITableView!
    
    var viewModel : VideoViewModel?
    
    public class func HomeViewController() -> HomeViewController {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        return viewController
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorCodes.ButtonBlueLight.color
        self.navigationController?.navigationBar.backItem?.backButtonTitle = ""
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: ""), style: .done, target: nil, action: nil)
        
        setupButtons()
        self.buttonHolder.isHidden = true
        setupViewModel()
        setupVideoListView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func setupViewModel() {
        
        self.viewModel = VideoViewModel(api: VideoServiceAPI())
        
        self.viewModel?.getVideos()
        
        setupObservers()
    }
    
    func setupObservers() {
        
        self.viewModel?.output.isLoadingDriver.drive(onNext: {[weak self] loading in
            
            guard let localSelf = self else {return}
            
            if loading {
                localSelf.loader?.showLoader()
            }
            else {
                localSelf.loader?.hideLoader()
            }
            
        }).disposed(by: bag)
        
        self.viewModel?.output.videoListDriver.drive(onNext: {[weak self] videos in
            guard let localSelf = self else {return}
            
            if videos.count > 0 {
                print("HomeViewcontroller : videos count : \(videos.count)")
                
                DispatchQueue.main.async {
                    localSelf.videoListTableView.reloadData()
                    localSelf.videoListTableView.setNeedsLayout()
                    localSelf.videoListTableView.layoutIfNeeded()
                }
                
            }
        }).disposed(by: bag)
        
    }
    
    func setupVideoListView() {
        
        videoListTableView.register(UINib(nibName: VideoItemCell.nibName(), bundle: Bundle(for: VideoItemCell.classForCoder())), forCellReuseIdentifier: VideoItemCell.cellIdentifier())
        videoListTableView.backgroundColor = ColorCodes.ButtonBlueLight.color
    }
    
    func setupButtons() {
        profileButton.setupStyle(type: .Profile)
        imageButton.setupStyle(type: .Image)
        audioButton.setupStyle(type: .Audio)
        videoButton.setupStyle(type: .Video)
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
        let profileVC = ProfileViewController.viewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func audioButtonAction(_ sender: HomeButtons) {
        
        loader?.showLoader()
        Task { @MainActor in
            
            if await signInWithGoogle() {
                
                loader?.hideLoader()
                let videoVC = VideoViewController.viewController()
                
                self.navigationController?.pushViewController(videoVC, animated: true)
            }
            else {
                
                loader?.hideLoader()
            }
            
        }
    }
    
    @IBAction func videoButtonAction(_ sender: HomeButtons) {
        let videoVC = VideoViewController.viewController()
        
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    public func signInWithGoogle() async -> Bool {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false}

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first , let rootViewController = window.rootViewController else {return false}
        
        do {
            let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
            let user = userAuth.user
            
            guard let idToken = user.idToken else {return false}
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            //print("signInWithGoogle : uid : \(firebaseUser.uid) : email : \(firebaseUser.email)")
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
    
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.videos?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoItemCell.cellIdentifier(), for: indexPath) as? VideoItemCell
        
        guard let item = self.viewModel?.videos?[indexPath.row] else {return UITableViewCell()}
        
        cell?.setupCell(item: item)
        
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = self.viewModel?.videos?[indexPath.row] else {return}
        
        let videoDetailsVC = VideoViewController.viewController(item: item)
        
        self.navigationController?.pushViewController(videoDetailsVC, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 10

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}
