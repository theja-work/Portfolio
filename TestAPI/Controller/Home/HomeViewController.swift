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

public class HomeViewController : BaseViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var buttonHolder: UIView!
    
    @IBOutlet weak var profileButton: HomeButtons!
    
    @IBOutlet weak var imageButton: HomeButtons!
    
    @IBOutlet weak var audioButton: HomeButtons!
    
    @IBOutlet weak var videoButton: HomeButtons!
    
    @IBOutlet weak var videoListTableView: UITableView!
    
    var accountButton : UIButton?
    
    
    var viewModel : VideoViewModel?
    
    public class func HomeViewController() -> HomeViewController {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        return viewController
        
    }
    
    public class func getNavigationController() -> UINavigationController {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let navController = storyBoard.instantiateViewController(withIdentifier: "HomeNavController") as! UINavigationController
        
        return navController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        //setupNavigationBar()
        setupButtons()
        self.buttonHolder.isHidden = true
        setupViewModel()
        setupVideoListView()
        printUser()
    }
    
    func printUser() {
        
        if let uuid = AppUserDefaults.getCurrentUserUUID() , let user = ProfileMangager().getProfileBy(id: uuid) {
            print("\(user.email_id)")
        }
        else {
            print("no users found")
        }
        
    }
    
    func setupNavigationBar() {
        
        let emptyItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain , target: self, action:  #selector(doNothing))
        
        self.navigationItem.leftBarButtonItem = emptyItem
        
        accountButton = UIButton(frame: .zero)
        
        var userImage = UIImage(named: "profile_placeholder")!
        
        if let uuid = AppUserDefaults.getCurrentUserUUID() , let user = ProfileMangager().getProfileBy(id: uuid) , let imageData = user.profilePicture , let image = UIImage(data: imageData) {
            userImage = image
        }
        
        accountButton?.setImage(userImage, for: .normal)
        accountButton?.addTarget(self, action: #selector(loadProfileScreen), for: .touchUpInside)
        
        accountButton?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        accountButton?.clipsToBounds = true
        accountButton?.layer.masksToBounds = true
        accountButton?.layer.cornerRadius = 8
        
        let rightItem = UIBarButtonItem(customView: accountButton!)
        
        rightItem.width = 45.0

        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    @objc func doNothing() {
        
    }
    
    @objc func loadProfileScreen() {
        
        let profileVC = ProfileViewController.viewController()
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        AppOrientation.lockOrientation(.portrait)
        updateUserThumbnail()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    func updateUserThumbnail() {
        var userImage = UIImage(named: "profile_placeholder")!
        
        if let uuid = AppUserDefaults.getCurrentUserUUID() , let user = ProfileMangager().getProfileBy(id: uuid) , let imageData = user.profilePicture , let image = UIImage(data: imageData) {
            userImage = image
        }
        
        accountButton?.setImage(userImage, for: .normal)
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
        
        videoListTableView.register(UINib(nibName: TV_BannerCell.getNibName(), bundle: Bundle(for: TV_BannerCell.classForCoder())), forCellReuseIdentifier: TV_BannerCell.getCellIdentifier())
        
        videoListTableView.register(UINib(nibName: TV_CatalogCell.getNibName(), bundle: Bundle(for: TV_CatalogCell.classForCoder())), forCellReuseIdentifier: TV_CatalogCell.getCellIdentifier())
        
        videoListTableView.backgroundColor = .clear
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
        
        guard let item = self.viewModel?.videos?[indexPath.row] else {return UITableViewCell()}
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TV_BannerCell.getCellIdentifier(), for: indexPath) as? TV_BannerCell
            
            cell?.selectionStyle = .none
            cell?.videos = self.viewModel?.videos
            cell?.setupCell(item: item, indexPath: indexPath, contentSelectionDelegate: self)
            return cell ?? UITableViewCell()
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TV_CatalogCell.getCellIdentifier(), for: indexPath) as? TV_CatalogCell
            
            cell?.selectionStyle = .none
            cell?.videos = self.viewModel?.videos
            cell?.setupCell(item: item, indexPath: indexPath,contentSelectionDelegate: self)
            return cell ?? UITableViewCell()
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 250.0
        }
        
        return 220.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = self.viewModel?.videos?[indexPath.row] else {return}
        
        let videoDetailsVC = VideoViewController.viewController(item: item)
        
        self.loader?.showLoader()
        self.navigationController?.pushViewController(videoDetailsVC, animated: true, completion: {
            self.loader?.hideLoader()
        })
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

extension UINavigationController {
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }

    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void)
    {
        popViewController(animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

extension HomeViewController : ContentSelectionProtocol {
    
    func contentSelected(item: VideoItem) {
        
        let videoDetailsVC = VideoViewController.viewController(item: item)
        
        self.loader?.showLoader()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(videoDetailsVC, animated: false, completion: {
            self.loader?.hideLoader()
        })
        
    }
}
