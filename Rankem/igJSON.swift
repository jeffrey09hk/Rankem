//
//  igJSON.swift
//  Rankem
//
//  Created by Jeff Hui on 19/7/2016.
//  Copyright © 2016 AffixGrp. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Acct {
    let name: String
    let rightsOwner: String
    let price: Double
    let link: String
    let releaseDate: String
    let posterLink: String
    
    init(){
        self.name = ""
        self.rightsOwner = ""
        self.price = 0
        self.link = ""
        self.releaseDate = ""
        self.posterLink = ""
    }
    
    init(json: JSON) {
        self.name = json["im:name"]["label"].stringValue
        self.rightsOwner = json["rights"]["label"].stringValue
        self.price = json["im:price"]["attributes"]["amount"].doubleValue
        self.link = json["link"][0]["attributes"]["href"].stringValue
        self.releaseDate = json["im:releaseDate"]["attributes"]["label"].stringValue
        self.posterLink = json["im:image"][0]["label"].stringValue
    }
}

