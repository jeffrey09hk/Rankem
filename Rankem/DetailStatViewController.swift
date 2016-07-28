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
import JBChartView


class DetailStatViewController: UIViewController, JBChartViewDataSource, JBChartViewDelegate{
    
    
    @IBOutlet weak var statChartView: JBBarChartView!
    
    var token: String = ""
    var userID: String = ""
    var testVal: CGFloat = 0.0
    
    // Count of chart Legend need to be the same as the count of chartData
    var chartLegend = ["a", "b", "c", "d", "e", "f", ]
    var chartData = [10, 30, 40, 20, 90, 30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show the navigationBar
        self.navigationController!.navigationBar.hidden = false
        
        // Set up the chart
        statChartView.delegate = self
        statChartView.dataSource = self
        
        statChartView.minimumValue = 0.0
        statChartView.maximumValue = 10.0
    
        statChartView.setState(.Collapsed, animated: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        statChartView.reloadData()
        
        // userInfo is for passing data to the showChart method
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart(){
        self.statChartView.setState(.Collapsed, animated: true)
    } // end of hideChart
    
    func showChart(){
        self.statChartView.setState(.Expanded, animated: true)
    } // end of showChart
    
    
    // MARK: Datasource
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt{
        return UInt(chartData.count)
    }
    
    func barChartView(barCharView: JBBarChartView, heightForBarViewAtIndex index: UInt) -> CGFloat{
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barCharView: JBBarChartView, colorForBarViewAtIndex index: UInt) -> UIColor!{
        return (index % 2 == 0) ? UIColor.lightGrayColor() : UIColor.cyanColor()
    }
    
    // MARK: Delegates
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}