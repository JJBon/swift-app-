//
//  DataManager.swift
//  iTunesTopTenMusic
//
//  Created by mruiz723 on 2/8/16.
//  Copyright © 2016 nextU. All rights reserved.
//

import Foundation

public typealias CompletionHandler = (success:Bool, jsonResponse:[String:AnyObject]) -> ()

class DataManager {

    
    //MARK: - Properties
    let url = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=10/json")
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    func topTenSongs(completion:CompletionHandler) {
        let urlRequest = NSURLRequest(URL: url!)
        dataTask = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            if let error = error{
                completion(success: false, jsonResponse: ["error" : error.localizedDescription])
            }else if let httpresponse = response as? NSHTTPURLResponse{
                if httpresponse.statusCode == 200 {
                    completion(success: true, jsonResponse: ["songs":data!])
                }else{
                    completion(success: false, jsonResponse: ["error":NSHTTPURLResponse.localizedStringForStatusCode(httpresponse.statusCode)])
                }
                
            }
        }
        
        dataTask?.resume()
    }
    
    func imageDataFromURL(url:NSURL, completion:CompletionHandler){
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if error == nil{
                completion(success: true, jsonResponse: ["data":data!])
            }else{
                completion(success: false, jsonResponse: ["error":(error?.localizedDescription)!])
            }
            
        }.resume()
    }

}