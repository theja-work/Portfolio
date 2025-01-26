//
//  VideoViewModelDependency.swift
//  PlayBox
//
//  Created by Thejas on 24/01/25.
//

import Foundation

protocol VideoViewModelDependency : AnyObject {
    
    var api : VideoServiceProtocol? { get }
    
    func getDataFromServer()
    
}

protocol VideoServiceProtocol : AnyObject {
    
    func getVideos(completion : @escaping (Dataloader<Data>) -> Void)
    func getCarousel(completion : @escaping (Dataloader<Data>) -> Void)
}
