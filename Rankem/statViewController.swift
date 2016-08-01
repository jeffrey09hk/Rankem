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
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var topPicture: UIImageView!
    @IBOutlet weak var statScroll: UIScrollView!
    @IBOutlet weak var rankingBar: MBCircularProgressBarView!
    
    
    var token: String = ""
    var userID: String = ""
    var fullName: String = ""
    dynamic var fansCount: Int = 0
    dynamic var followCount: String = ""
    var profilePicLink: String = ""
    
    dynamic var likeCount: Int = 0
    dynamic var commentCount: Int = 0
    var ratioIndex = [Double]()
    var maxIndex: Double = 0
    
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
            // if responseData is not nil
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
                    
                    // Sandbox mode only allow 20 pics
                    for counter in 0...19{
                        // get the total like and comment count
                        self.likeCount += mediaData["data"][counter]["likes"]["count"].intValue
                        self.commentCount += mediaData["data"][counter]["comments"]["count"].intValue
                        
                        // Calculate Likes to comment ratio and append into the array
                        // If comment count is 0, append 0 to the array as index, prevent from dividing by 0
                        
                        if (mediaData["data"][counter]["comments"]["count"].intValue == 0){
                            self.ratioIndex.append(0)
                        }
                        else{
                            var ratio = Double(mediaData["data"][counter]["likes"]["count"].intValue) / Double(mediaData["data"][counter]["comments"]["count"].intValue)
                        
                            ratio = ratio.roundToPlaces(1)
                            self.ratioIndex.append(ratio)
                            
                            // Get the max index for setting up the graph height in the next view controller
                            if ratio > self.maxIndex {
                                self.maxIndex = ratio
                            }
                            
                        }
                        
                        // Find the picture with the highest amount of likes
                        if mediaData["data"][counter]["likes"]["count"].intValue > highestLikeCount{
                            highestLikeCount = mediaData["data"][counter]["likes"]["count"].intValue
                            pos = counter
                        }
                        
                    } // end of for loops
                    
                    self.likeCountLabel.text = String(mediaData["data"][pos]["likes"]["count"].intValue)
                    
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
        
        // set the ranking value to the progress bar
        self.rankingBar.maxValue = CGFloat(score)
        self.rankingBar.setValue(CGFloat(score), animateWithDuration: 1.0)
        self.rankingBar.progressLineWidth = (CGFloat(3.5))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC: DetailStatViewController = segue.destinationViewController as! DetailStatViewController
//        self.performSegueWithIdentifier("yo", sender: self)
        // passing the token to the DetailStatViewController
        // use this for the follower list
        destVC.token = self.token
        destVC.userID = self.userID
        destVC.ratioIndex = self.ratioIndex
        destVC.maxIndex = self.maxIndex
    }

    
//    func roundToPlaces(value: Double, decimalPlaces: Int) -> Double {
//        let divisor = pow(10.0, Double(decimalPlaces))
//        return round(value * divisor) / divisor
//    }
    
    
} // end of class


extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
