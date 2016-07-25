//
//  webViewController.swift
//  Rankem
//
//  Created by Jeff Hui on 15/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class webViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var webViewer: UIWebView!
    var token: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewer.backgroundColor = UIColor.clearColor()
        // hide the navigation bar
        self.navigationController!.navigationBar.hidden = true
        let clientID: String = "c1838847866d40dfb3c2ce0a30d1d1d5"
        let redirectURI: String = "https://www.example.com"
        let url = NSURL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=token&scope=basic+public_content+follower_list+comments+relationships+likes")
        
        // &scope=basic+public_content+follower_list+comments+relationships+likes <--- try to get the max_id to fetch more than 20 photos
        let request = NSURLRequest(URL: url!)
        webViewer.loadRequest(request)
        webViewer.delegate = self
      
    } // end of viewDidLoad
    
    
    // make the webViewer scale with the size of the phone
    func webViewDidFinishLoad(webView: UIWebView) {
        let contentSize: CGSize = webViewer.scrollView.contentSize
        let viewSize: CGSize = webViewer.bounds.size
        let rw = viewSize.width / contentSize.width
        
        webViewer.scrollView.minimumZoomScale = rw
        webViewer.scrollView.maximumZoomScale = rw
        webViewer.scrollView.zoomScale = rw
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
       // print("main: \(request.mainDocumentURL!)")
        
        // getting the token from the redirect URI
        
        if request.mainDocumentURL != nil{
            let parts = String(request.mainDocumentURL!)
            token = parts.componentsSeparatedByString("=")[1]
//            print ("this is the part: \(token)")
            
            
            // transition to the stat page after we get the token
            if parts.componentsSeparatedByString("=")[0] == "https://www.example.com/#access_token"{
                performSegueWithIdentifier("showStat", sender: self)
                print(parts.componentsSeparatedByString("=")[1])
            }
            else{
                
                print("not the token")
            }
        }
        return true
    } // end of webView
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC: statViewController = segue.destinationViewController as! statViewController
        
        // passing the token to the statViewController
        destVC.token = self.token
    }


} // end of class