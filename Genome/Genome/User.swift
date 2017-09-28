//
//  User.swift
//  Genome
//
//  Created by Egan Anderson on 4/4/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class User: NSObject {
    let userID: String
    var dataCategories: [DataCategory]?
    
    var accounts: [String]?
    var permissionsForAccount: [String : [String]]?
    var permissionStatus: [String : [String : Bool]]?
    
    var apps: [String]?
    var scopesForApp: [String : [String]]?
    var scopesStatus: [String :[String : Bool]]?
    
    var bio: Bio?
    var experience: Experience?
    var social: Social?
    var entertainment: Entertainment?
    var location: Location?
    var sports: Sports?
    
    init(userID: String) {
        self.userID = userID
        dataCategories = []
        accounts = []
        permissionsForAccount = [:]
        permissionStatus = [:]
        apps = []
        scopesForApp = [:]
        scopesStatus = [:]
    }
    
//    func updateUser(dataCategories: [DataCategory]?) {
//        self.dataCategories = dataCategories
//    }
}
