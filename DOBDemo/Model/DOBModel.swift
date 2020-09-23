//
//  DOBModel.swift
//  DOBDemo
//
//  Created by VJ's iMAC on 23/09/20.
//  Copyright © 2020 VJ's. All rights reserved.
//

import Foundation
import ObjectMapper

struct Person: Mappable {
    
    var name: String?
    var dob: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.dob <- map["dob"]
        
    }
    
    
}


