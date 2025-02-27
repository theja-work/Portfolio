//
//  VideoViewModelDependency.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation

protocol VideoViewModelDependency : AnyObject {
    
    var api : VideoServiceProtocol? { get }
    var carouselItems : [VideoItem]? { get set }
    var catalogItems : [VideoItem]? { get set }
    
    func getDataFromServer()
    
}

protocol VideoServiceProtocol : AnyObject {
    
    func getVideos(completion : @escaping (Dataloader<[VideoItem]>) -> Void)
    func getCarousel(completion : @escaping (Dataloader<[VideoItem]>) -> Void)
}
