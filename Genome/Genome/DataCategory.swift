//
//  DataCategory.swift
//  Genome
//
//  Created by Egan Anderson on 4/11/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class DataCategory: NSObject {
    let name: String
    let value: String?
    var subCategories: [DataCategory]?
    var data: [AnyObject]
    var parentCategory: DataCategory?
    
    init(name: String, value: String?) {
        self.name = name
        self.value = value
        subCategories = []
        data = []
    }
    
}
