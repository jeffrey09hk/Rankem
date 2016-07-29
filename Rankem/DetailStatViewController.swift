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


class DetailStatViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate{
    
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var statChartView: JBLineChartView!
    
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
        let footer = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 16))
        footer.textColor = UIColor.whiteColor()
        footer.text = "\(chartLegend[0]) to \(chartLegend[chartLegend.count - 1])"
        footer.textAlignment = NSTextAlignment.Center
        
        let header = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 50))
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
        showChart()
        
        // userInfo is for passing data to the showChart method
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
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
    
    
    // MARK: Datasource & Delegates
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if (lineIndex == 0){
            return UInt(chartData.count)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0){
            return CGFloat(chartData[Int(horizontalIndex)])
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if (lineIndex == 0){
            return UIColor.lightGrayColor()
        }
        return UIColor.lightGrayColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightGrayColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        if (lineIndex == 0){
            let data = chartData[Int(horizontalIndex)]
            let key = chartLegend[Int(horizontalIndex)]
            infoLabel.text = "the data is: \(data) and key: \(key)"
        }
    }
    
    func lineChartView(lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.cyanColor()
    }
    
    func didDeselectBarChartView(lineChartView: JBLineChartView!){
    
        infoLabel.text = ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}