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


class DetailStatViewController: UIViewController{
    
    var token: String = ""
    var userID: String = ""
    
    override func viewDidLoad() {
        self.navigationController!.navigationBar.hidden = false
    }
    
    
}