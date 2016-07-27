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
    
    
    @IBOutlet weak var progressViewBar: MBCircularProgressBarView!

    var token: String = ""
    var userID: String = ""
    var testVal: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = false
        //self.manageCircularProgressBar()
        //progressViewBar.setValue(testVal, animateWithDuration: 300)
    }
    
    @IBAction func testSlider(sender: UISlider) {
        progressViewBar.value = CGFloat(sender.value)
    }
    
}