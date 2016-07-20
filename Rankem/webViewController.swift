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
        
        // hide the navigation bar for
        self.navigationController!.navigationBar.hidden = true
        let clientID: String = "c1838847866d40dfb3c2ce0a30d1d1d5"
        let redirectURI: String = "https://www.example.com"
        let url = NSURL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=token")
        
        
        let request = NSURLRequest(URL: url!)
        webViewer.loadRequest(request)
        webViewer.delegate = self
      
        
    } // end of viewDidLoad
    
    
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