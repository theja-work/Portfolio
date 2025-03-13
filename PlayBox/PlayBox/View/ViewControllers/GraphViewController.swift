//
//  GraphViewController.swift
//  PlayBox
//
//  Created by Thejas on 13/01/25.
//

import Foundation
import UIKit
import PhotosUI

class GraphViewController : UIViewController {
    
    class func viewController() -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "GraphVC") as? GraphViewController
        
        return viewController
        
    }
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var transferProgress: UIProgressView!
    
    let loader = Loader(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemTeal
        
        loader.addLoader(to: self.view)
        transferProgress.isHidden = true
    }
    
    @objc func pickVideo() {
        var config = PHPickerConfiguration()
        config.filter = .videos
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func uploadVideo(fileURL: URL) {
        
        let cloudName = "dxgyvupab"
        let uploadPreset = "com.logicode.ios.PlayBox" // Create an unsigned preset in Cloudinary settings
        let uploadURL = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/video/upload")!
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let videoData = try? Data(contentsOf: fileURL)
        var body = Data()
        
        // Upload preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        // Video file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"video.mov\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: video/quicktime\r\n\r\n".data(using: .utf8)!)
        body.append(videoData!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        session.uploadTask(with: request, from: body) { data, response, error in
            
            if let error = error {
                print("Upload error: \(error)")
                return
            }
            
            if let data = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let secureURL = jsonResponse["secure_url"] as? String {
                print("Uploaded Video URL: \(secureURL)")
            }
        }
        
        let uploadTask = session.uploadTask(with: request, from: body)
        uploadTask.resume()
        
    }

    
    @IBAction func uploadAction(_ sender : UIAction) {
        
        loader.showLoader()
        pickVideo()
        
    }
    
    @IBAction func downloadAction(_ sender : UIAction) {
        
        if let downloadsVC = DownloadsViewController.viewController() {
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(downloadsVC, animated: true)
        }
    }
    
}

extension GraphViewController : PHPickerViewControllerDelegate , URLSessionDelegate , URLSessionDataDelegate , URLSessionTaskDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.hasItemConformingToTypeIdentifier("public.movie") else { return }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
            if let fileURL = url {
                print("Picked video URL: \(fileURL)")
                self.uploadVideo(fileURL: fileURL)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        //progressHandler?(progress)
        
        if totalBytesSent == bytesSent {
            print("Upload Started")
            DispatchQueue.main.async {
                self.transferProgress.isHidden = false
                
            }
        }
        
        //AppUtilities.shared.log("Upload progress : \((progress * 100).rounded() / 100 * 100) %")
        
        DispatchQueue.main.async {
            self.transferProgress.setProgress(progress, animated: true)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
           let responseDict = jsonResponse as? [String: Any],
           let secureURL = responseDict["secure_url"] as? String {
            //completionHandler?(.success(secureURL))
            //AppUtilities.shared.log("Upload succeed : \(secureURL)")
            
            DispatchQueue.main.async {
                self.transferProgress.setProgress(0, animated: false)
                self.transferProgress.isHidden = true
                self.loader.hideLoader()
            }
            
        } else {
            //completionHandler?(.failure(NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
        }
    }
    
}
