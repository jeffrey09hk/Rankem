//
//  ViewController.swift
//  Rankem
//
//  Created by Jeff Hui on 14/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(sender: AnyObject) {
        print("button pressed")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
    }
    
    


}

