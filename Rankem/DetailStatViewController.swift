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
    var maxIndex: Double = 0.0
    var ratioIndex = [Double]()
    
    
    // The count of chart Legend need to be the same as the count of ratioIndex
    var chartLegend = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show the navigationBar
        self.navigationController!.navigationBar.hidden = true
        
        // Set up the chart
        statChartView.delegate = self
        statChartView.dataSource = self
        
        statChartView.minimumValue = 0.0
        statChartView.maximumValue = CGFloat(maxIndex + 5)
    
        statChartView.setState(.Collapsed, animated: false)
        
        
        // header footer
        let footer = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 16))
        footer.textColor = UIColor.yellowColor()
        footer.textAlignment = NSTextAlignment.Center
        
        let header = UILabel(frame: CGRectMake(0, 0, statChartView.frame.width, 50))
        header.textColor = UIColor.whiteColor()
        header.text = "Likes to Comments Ratio"
        header.textAlignment = NSTextAlignment.Center
        header.font = UIFont(name: "texgyreadventor-regular", size: 20)
        
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
            return UInt(ratioIndex.count)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0){
            return CGFloat(ratioIndex[Int(horizontalIndex)])
        }
        return 0
    }
    
    // Setting the color of the top line of the graph
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        let darkMidNightBlue = hexStringToUIColor("#3DDC97")
        if (lineIndex == 0){
            return darkMidNightBlue
        }
        return darkMidNightBlue
    }
    
    // Whether to show a dot for every data point of the graph
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    // Smooth angle on the line
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    // changing the info lable according to the selection of the graph
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        if (lineIndex == 0){
            let data = ratioIndex[Int(horizontalIndex)]
            let key = chartLegend[Int(horizontalIndex)]
            infoLabel.font = UIFont(name: "texgyreadventor-regular", size: 18)
            infoLabel.text = "The ratio is: \(data)"
        }
    }
    
    // the color of selection
    func lineChartView(lineChartView: JBLineChartView!, verticalSelectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightTextColor()
    }
    
    
    // change the color of the graph during selection
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        let darkMidNightBlue = hexStringToUIColor("#3DDC97")
        return darkMidNightBlue
    }
    
    
    // filling the line chart
//    func lineChartView(lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
//        return UIColor.cyanColor()
//    }
    
    // Reset the text when deselect
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        infoLabel.text = ""
    }
    
    // convert hex color to UIcolor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
   
} // end of class