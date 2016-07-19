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
    
    // request = https://www.example.com/#access_token=9965006.c183884.497885c7f1fa41f2a8fa05e21a5a64ef
    let jLink = "https://api.instagram.com/v1/users/self/?access_token=9965006.c183884.497885c7f1fa41f2a8fa05e21a5a64ef"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://api.instagram.com/oauth/authorize/?client_id=c1838847866d40dfb3c2ce0a30d1d1d5&redirect_uri=https://www.example.com&response_type=token")
        
        let request = NSURLRequest(URL: url!)
        // print ("First print \(url!)")
        webViewer.loadRequest(request)
        webViewer.delegate = self
      //  printJSON()
        
    } // end of viewDidLoad
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        print("main: \(request.mainDocumentURL!)")
        
        // getting the token from the redirect URI
        
        if request.mainDocumentURL != nil{
            let parts = String(request.mainDocumentURL!)
            let token = parts.componentsSeparatedByString("=")[1]
            print ("\n this is the part: \(token)")
            
            
            // transition to the stat page after we get the token
            if parts.componentsSeparatedByString("=")[0] == "https://www.example.com/#access_token"{
                performSegueWithIdentifier("showStat", sender: self)
            }
        }
        
        return true
    }

    
    
    func printJSON(){
        Alamofire.request(.GET, jLink).validate().responseJSON() { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    let allData = JSON(value)
                    let someData = allData["data"].arrayValue
                    print()
                    print("Here are the JSON: \(allData)")
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    } // end of printJSON
    


} // end of class