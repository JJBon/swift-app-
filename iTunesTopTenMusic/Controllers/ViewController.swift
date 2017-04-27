//
//  ViewController.swift
//  iTunesTopTenMusic
//
//  Created by mruiz723 on 2/8/16.
//  Copyright © 2016 nextU. All rights reserved..
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Properties
    let cellIdentifier = "MusicCell"
    var songs = [Song]()
    var imageCache = [NSData]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Song.topTenSongs{ (success, jsonResponse) -> () in
            if success{
                self.songs = (jsonResponse["songs"] as? [Song])!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }else{
                print("Error: \(jsonResponse["error"])")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndicator.stopAnimating()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MusicCell
        let song = songs[indexPath.row]
        
        cell.titleLabel.text = song.name
        cell.artistLabel.text = song.artist

        if let imageURL = song.images?.first{
            if indexPath.row < imageCache.count{
                cell.songImageView?.image = UIImage(data: imageCache[indexPath.row])
            }else{
                Song.imagesDataFromURL(imageURL, completion: { (success, jsonResponse) -> () in
                    if success{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in

                            if let imageData = jsonResponse["data"] as? NSData{
                                let index = self.songs.indexOf{$0 === song}
                                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                                if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? MusicCell{
                                    if index <= self.imageCache.count{
                                        self.imageCache.insert(imageData, atIndex: index!)
                                    }
                                    cellToUpdate.songImageView?.image = UIImage(data: imageData)
                                }
                            }
                        })
                        
                        
                    }else{
                        print(jsonResponse["error"])
                    }
                })
            }
        }
        return cell
    }
    
}

