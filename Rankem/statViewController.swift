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
import MBCircularProgressBar

class statViewController: UIViewController{
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
//    @IBOutlet weak var followingLabel: UILabel!
//    @IBOutlet weak var followedByLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var topPicture: UIImageView!
//    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var statScroll: UIScrollView!
    @IBOutlet weak var rankingBar: MBCircularProgressBarView!
    
    
    var token: String = ""
    var userID: String = ""
    var fullName: String = ""
    var fansCount: Int = 0
    var followCount: String = ""
    var profilePicLink: String = ""
    
    var likeCount: Int = 0
    var commentCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Stat Page token: \(token)")
        getUserInfo()
        print("YOOOOO \(profilePicLink)")
        getMediaInfo()
        imSuperPopular()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = true
        navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
    
    
    func getUserInfo(){
    
        let userInfoLink: String = "https://api.instagram.com/v1/users/self/?access_token=\(token)"
        
        Alamofire.request(.GET, userInfoLink).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    let userData = JSON(value)
                    
                    print("set fansCount and followCount")
                    
                    self.userID = String(userData["data"]["id"])
                    self.fullName = String(userData["data"]["full_name"])
                    self.fansCount = userData["data"]["counts"]["followed_by"].intValue
                    self.followCount = String(userData["data"]["counts"]["follows"])
                    self.profilePicLink = String(userData["data"]["profile_picture"])
                    
                    // Properties of the profile picture, make the picture circular
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
                    self.profilePic.clipsToBounds = true
                    statViewController.loadImageFromUrl(self.profilePicLink, view: self.profilePic)
                    
                    // Assign value to labels on page
                    self.fullnameLabel.text = self.fullName
//                    self.followingLabel.text = self.followCount
//                    self.followedByLabel.text = String(self.fansCount)
                    
                    self.imSuperPopular()
                    
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
        
        let userMediaLink: String = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(token)"
        
        Alamofire.request(.GET, userMediaLink).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    let mediaData = JSON(value)
                    var highestLikeCount: Int = 0
                    var pos: Int = 0
                    
                    print("set likeCount")
                    
                    // Sandbox mode only allow 20 pics
                    for counter in 0...19{
                        // get the total like and comment count
                        self.likeCount += mediaData["data"][counter]["likes"]["count"].intValue
                        self.commentCount += mediaData["data"][counter]["comments"]["count"].intValue
                        
                        // Find the picture with the highest amount of likes
                        if mediaData["data"][counter]["likes"]["count"].intValue > highestLikeCount{
                            highestLikeCount = mediaData["data"][counter]["likes"]["count"].intValue
                            pos = counter
                        }
                        
                    } // end of for loops
                    
                    self.likeCountLabel.text = String(self.likeCount)
                    
                    // get the thumbnail of the most liked picture and link to the imgView
                    let topPicLink = String(mediaData["data"][pos]["images"]["thumbnail"]["url"])
                    
                    
                    // Make the picture circular
                    statViewController.loadImageFromUrl(topPicLink, view: self.topPicture)
                    self.topPicture.layer.cornerRadius = self.profilePic.frame.size.height / 2
                     self.topPicture.layer.cornerRadius = self.profilePic.frame.size.width / 2
                    self.topPicture.clipsToBounds = true
                    
                    
                    self.imSuperPopular()
                    
                }
            case .Failure(let error):
                print(error)
            }
        } // end of alamofire
    } // end of getMediaInfo
    
    
    func imSuperPopular(){
        
        let weightedComments = self.commentCount * 5
        let weightedFans = self.fansCount * 10
        let score: Int = weightedComments + weightedFans + self.likeCount
//        self.rankingLabel.text = String(score)
        self.rankingBar.maxValue = CGFloat(score)
        self.rankingBar.setValue(CGFloat(score), animateWithDuration: 0.8)
        self.rankingBar.progressLineWidth = (CGFloat(3.5))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC: DetailStatViewController = segue.destinationViewController as! DetailStatViewController
        
        // passing the token to the DetailStatViewController
       //  destVC.token = self.token
//        destVC.userID = self.userID
    }

    
    
} // end of class