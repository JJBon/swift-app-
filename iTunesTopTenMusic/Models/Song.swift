//
//  Song.swift
//  iTunesTopTenSongs
//
//  Created by mruiz723 on 2/8/16.
//  Copyright © 2016 nextU. All rights reserved..
//

import Foundation

typealias Payload = [String: AnyObject]

class Song {
    
    //MARK: - Properties
    var name:String?
    var category:String?
    var images:[NSURL]?
    var artist:String?
    var price:String?
    
    class func topTenSongs(completion:CompletionHandler) {
        var songs = [Song]()
        let dataManager = DataManager()
        dataManager.topTenSongs { (success, jsonResponse) -> () in
            if success{
                var json : Payload!
                do{
                    let data = jsonResponse["songs"] as! NSData
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
                }catch{
                    completion(success: false, jsonResponse: ["error":"JSonSerialization"])
                }
                
                guard let feed = json!["feed"] as? Payload,
                    let SongsArray = feed["entry"] as? [AnyObject]
                    else {
                        completion(success: false, jsonResponse: ["error":"UnWrapping"])
                        return
                }
                for item in SongsArray{
                    let song = Song()
                    var images = [NSURL]()
                    
                    //name
                    guard let containerName = item["im:name"] as? Payload,
                        let name = containerName["label"] as? String
                        else{
                            completion(success: false, jsonResponse: ["error":"UnWrapping"])
                            return
                    }
                    song.name = name
                    
                    //category
                    guard let containerCategory = item["category"] as? Payload,
                        let categoryArray = containerCategory["attributes"] as? Payload,
                        let category = categoryArray["label"] as? String
                        else{
                            completion(success: false, jsonResponse: ["error":"UnWrapping"])
                            return
                    }
                    song.category = category
                    
                    //images
                    guard let containerImages = item["im:image"] as? [AnyObject]
                        else{
                            completion(success: false, jsonResponse: ["error":"UnWrapping"])
                            return
                    }
                    
                    for itemImage in containerImages{
                        guard let image = itemImage["label"] as? String
                            else{
                                completion(success: false, jsonResponse: ["error":"UnWrapping"])
                                return
                            }
                        images.append(NSURL(string: image)!)
                    }
                    
                    song.images = images
                    
                    //artist
                    guard let containerArtist = item["im:artist"] as? Payload,
                        let artist = containerArtist["label"] as? String
                        else{
                            completion(success: false, jsonResponse: ["error":"UnWrapping"])
                            return
                    }
                    song.artist = artist
                    
                    //price
                    guard let containerPrice = item["im:price"] as? Payload,
                        let price = containerPrice["label"] as? String
                        else{
                            completion(success: false, jsonResponse: ["error":"UnWrapping"])
                            return
                    }
                    song.price = price
                    songs.append(song)
                }
                
                completion(success: success, jsonResponse: ["songs":songs])
            }else{
                completion(success: success, jsonResponse: jsonResponse)
            }
        }
    }
    
    class func imagesDataFromURL(url:NSURL, completion:CompletionHandler){
        let dataManager = DataManager()
        dataManager.imageDataFromURL(url) { (success, jsonResponse) -> () in
            completion(success: success, jsonResponse: jsonResponse)
        }
    }
   
}


