//
//  Account.swift
//  Genome
//
//  Created by Egan Anderson on 4/4/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Account: NSObject {
    let accountType: String
    var imageColor: UIImage?
    var imageGray: UIImage?
    var token: String?
    var refreshToken: String?
    var lastAccessedTime: Date?
    var expirationTime: TimeInterval?
    var isUpToDate: Bool
    
    init(type: String) {
        accountType = type
        isUpToDate = false
        switch type {
        case "facebook":
            imageColor = UIImage.init(named: "facebook_color")!
            imageGray = UIImage.init(named: "facebook_gray")!
            expirationTime = TimeInterval.init(1000000)
            break
        case "google":
            imageColor = UIImage.init(named: "google_color")!
            imageGray = UIImage.init(named: "google_gray")!
            expirationTime = TimeInterval.init(1000000)
            break
        case "spotify":
            imageColor = UIImage.init(named: "spotify_color")!
            imageGray = UIImage.init(named: "spotify_gray")!
            expirationTime = TimeInterval.init(3600)
            break
        case "pinterest":
            imageColor = UIImage.init(named: "pinterest_color")!
            imageGray = UIImage.init(named: "pinterest_gray")!
            expirationTime = TimeInterval.init(1000000)
            break
        default:
            break
        }
        token = nil
        refreshToken = nil
        lastAccessedTime = nil
    }
    
    func updateAccount(token: String, refreshToken: String, lastAccessedTime: Date) {
        self.token = token
        self.refreshToken = refreshToken
        self.lastAccessedTime = lastAccessedTime
        self.isUpToDate = true
    }
}

