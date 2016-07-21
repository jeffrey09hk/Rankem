//
//  statViewController.swift
//  Rankem
//
//  Created by Jeff Hui on 19/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class statViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followedByLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    var token: String = ""
    var userID: String = ""
    var fullName: String = ""
    var fansCount: String = ""
    var followCount: String = ""
    var profilePicLink: String = ""
    
    var likeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Stat Page token: \(token)")
        getUserInfo()
        print("YOOOOO \(profilePicLink)")
        getMediaInfo()
        
    }
    
    func getUserInfo(){
        
        let userInfoLink: String = "https://api.instagram.com/v1/users/self/?access_token=\(token)"
        
        Alamofire.request(.GET, userInfoLink).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    let userData = JSON(value)
                    
                    self.userID = String(userData["data"]["id"])
                    self.fullName = String(userData["data"]["full_name"])
                    self.fansCount = String(userData["data"]["counts"]["followed_by"])
                    self.followCount = String(userData["data"]["counts"]["follows"])
                    self.profilePicLink = String(userData["data"]["profile_picture"])
                    
                    // Properties of the profile picture
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
                    self.profilePic.clipsToBounds = true
                    statViewController.loadImageFromUrl(self.profilePicLink, view: self.profilePic)
                    
                    // Assign value to labels on page
                    self.fullnameLabel.text = self.fullName
                    self.followingLabel.text = self.followCount
                    self.followedByLabel.text = self.fansCount
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    } // end of getUserInfo
    
    static func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download picture from url:
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        // Run task
        task.resume()
    } // end of load image from url
    
    
    func getMediaInfo(){
        // Sandbox mode only allow 20 pics
        let userMediaLink: String = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(token)"
        
        Alamofire.request(.GET, userMediaLink).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    let mediaData = JSON(value)
                    var highestLikeCount: Int = 0
                    var pos: Int
                    
                    for counter in 0...19{
                        // get the total like count
                        self.likeCount += mediaData["data"][counter]["likes"]["count"].intValue
                        
                        
                        // Find the picture with the highest amount of likes
                        if mediaData["data"][counter]["likes"]["count"].intValue > highestLikeCount{
                            highestLikeCount = mediaData["data"][counter]["likes"]["count"].intValue
                            pos = counter
                        }
                        
                    }
                    self.likeCountLabel.text = String(self.likeCount)
                }
            case .Failure(let error):
                print(error)
            }
    
        } // end of alamofire
    
    }
} // end of class