//
//  DetailStatViewController.swift
//  Rankem
//
//  Created by Jeff Hui on 25/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import MBCircularProgressBar


class DetailStatViewController: UIViewController{
    
    


    var token: String = ""
    var userID: String = ""
    var testVal: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show the navigationBar
        self.navigationController!.navigationBar.hidden = false
    }
    
    
}