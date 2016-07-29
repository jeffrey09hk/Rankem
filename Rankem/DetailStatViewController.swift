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


class DetailStatViewController: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate{
    
    
    @IBOutlet weak var footerLabel: UILabel!
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
        
        
        // header footer
        var footer = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 16))
        footer.textColor = UIColor.whiteColor()
        footer.text = "\(chartLegend[0]) to \(chartLegend[chartLegend.count - 1])"
        footer.textAlignment = NSTextAlignment.Center
        
        var header = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 50))
        header.textColor = UIColor.whiteColor()
        header.font = UIFont.systemFontOfSize(24)
        header.text = "this is the header"
        header.textAlignment = NSTextAlignment.Center
        
        // add footer and header to the chart
        statChartView.footerView = footer
        statChartView.headerView = header
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        statChartView.reloadData()
        
        // userInfo is for passing data to the showChart method
        var timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
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
    
    func barChartView(barChartView: JBBarChartView, heightForBarViewAtIndex index: UInt) -> CGFloat{
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView, colorForBarViewAtIndex index: UInt) -> UIColor!{
        return (index % 2 == 0) ? UIColor.lightGrayColor() : UIColor.cyanColor()
    }
    
    // MARK: Delegates
    
    func barChartView(barChartView: JBBarChartView, didSelectBarAtIndex index: UInt){
    
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        footerLabel.text = "the data is: \(data) and key: \(key)"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!){
    
        footerLabel.text = ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}