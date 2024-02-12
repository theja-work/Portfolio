//
//  VideoViewModel.swift
//  TestAPI
//
//  Created by Thejas K on 23/08/23.
//

import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

public class VideoViewModel {
    
    fileprivate var api : VideoServiceProtocol?
    var videos:[VideoItem]?
    
    public init(api: VideoServiceProtocol) {
        self.api = api
    }
    
    struct Output {
        
        var isLoadingSubject : BehaviorSubject<Bool>
        var isLoadingDriver : Driver<Bool>
        
        var videoListSubject : BehaviorSubject<[VideoItem]>
        var videoListDriver : Driver<[VideoItem]>
        
        init() {
            
            isLoadingSubject = BehaviorSubject(value: false)
            isLoadingDriver = isLoadingSubject.asDriver(onErrorJustReturn: false)
            
            videoListSubject = BehaviorSubject(value: [])
            videoListDriver = videoListSubject.asDriver(onErrorJustReturn: [])
            
        }
        
    }
    
    var output = Output()
    
    public func getDataFromServer(responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        
        self.api?.getVideoItem(response: responseHandler)
        
    }
    
    public func getDataFromServerWith(videoLink : String , responseHandler : @escaping (_ response:DataLoader<VideoItem>) -> Void) {
        self.api?.getViedoItemFromLink(link: videoLink, response: responseHandler)
    }
    
    public func getVideosFromServer(responseHandler : @escaping (_ response:DataLoader<[VideoItem]>) -> Void) {
        self.api?.getVideos(response: responseHandler)
        
    }
    
    public func getVideos() {
        
        guard let isBusy = try? self.output.isLoadingSubject.value() else {return}
        if isBusy {return}
        
        self.output.isLoadingSubject.onNext(true)
        getVideosFromServer { [weak self] videoListResponse in
            
            guard let strongSelf = self else {return}
            strongSelf.output.isLoadingSubject.onNext(false)
            
            switch videoListResponse {
            case .success(let videos) :
                
                DispatchQueue.main.async {
                    strongSelf.videos = videos
                    strongSelf.output.videoListSubject.onNext(videos)
                }
                
            case .serverError(let error, let message):
                print("VideoViewModel : server error with error : \(error) : \(message)")
                
            case .dataNotFound :
                print("VideoViewModel : data not found")
                
            case .networkError :
                print("VideoViewModel : connection error")
                
            }
            
        }
        
    }
    
    public func getRelatedVideosWithId(videoID:String,completionHanlder:@escaping ((_ response : DataLoader<[VideoItem]>) -> Void)) {
        
        guard let isBusy = try? self.output.isLoadingSubject.value() else {return}
        if isBusy {return}
        
        self.output.isLoadingSubject.onNext(true)
        
        self.api?.getVideosWithId(videoId: videoID, response: completionHanlder)
        
    }
    
    public func getVideosCount() -> Int? {
        
        if let count = videos?.count {return count}
        
        return nil
        
    }
    
}
