//
//  apiManager.swift
//  Rankem
//
//  Created by Jeff Hui on 14/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class apiManager{
    static let sharedInstance = apiManager()
    
    var OAuthTokenCompletionHandler:(NSError? -> Void)?
    
    var clientID: String = "c1838847866d40dfb3c2ce0a30d1d1d5"
    var clientSecret: String = "33b53b92b53042cd8340f2c2ddcddbdb"
    
    
    func hasOAuthToken() -> Bool{
    
    }
    
    func startOAuth2Login(){
        
        let authPath: String = "https://api.instagram.com"
        
        if let authURL:NSURL = NSURL(string: authPath){
            UIApplication.sharedApplication().openURL(authURL)
        }
    }
    
    func loadInitialData(){
        if (!apiManager.sharedInstance.hasOAuthToken()){
            apiManager.sharedInstance.startOAuth2Login()
        }
        else{
            fetchMyRepos()
        }
    } // end of func
} // end of apiManager