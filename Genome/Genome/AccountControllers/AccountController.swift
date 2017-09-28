//
//  AccountController.swift
//  Genome
//
//  Created by Egan Anderson on 4/4/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation
import UIKit

class AccountController: NSObject {
    
    var host = "http://35.165.224.147:60000/"
    //var host = "http://localhost:60000/"
    var allAccounts: [Account]?
    
    // the singleton for our person controller
    static let sharedInstance = AccountController()
    
    fileprivate override init() {
        allAccounts = [Account(type: "facebook"), Account(type: "google"), Account(type: "spotify"), Account(type: "pinterest")]
    }

    func getAccounts(userID: String) {
        
    }
    
    func connectAccount(type: String, token: String) {
        let account = getAccount(type: type)
        self.sendTokenToServer(host: self.host, token: token, service: type)
        account.updateAccount(token: token, refreshToken: "refresh_token", lastAccessedTime: Date())
    }
    
    //MARK: - Send Tokens To servers

    func sendTokenToServer(host: String, token: String, service: String){
        let userController = UserController.sharedInstance
        var tokens = userController.oauthTokens[(userController.currentUser?.userID)!]
        if (tokens == nil) {
            tokens = [:]
        }
        tokens?[service] = token
        userController.oauthTokens[(userController.currentUser?.userID)!] = tokens        
        userController.save()
        
        let serviceLabel = getServiceLabel(service: service)
        
        var request = URLRequest(url: URL(string: host + service + "/token")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + (userController.currentUser?.userID)! + "\",\"" + serviceLabel + "\":\"" + token + "\"}"
        print(token)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 202) {  // check for http errors
                print("statusCode should be 202, but is \(httpStatus.statusCode)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func getAccount(type: String) -> Account {
        switch type {
        case "facebook":
            return allAccounts![0]
        case "google":
            return allAccounts![1]
        case "spotify":
            return allAccounts![2]
        case "pinterest":
            return allAccounts![3]
        default: return Account(type: "invalid")
        }
    }
    
    func getServiceLabel(service: String) -> String {
        switch service {
        case "spotify":
            return "SpotifyToken"
        case "facebook":
            return "FacebookToken"
        default:
            return "InvalidService"
        }
    }

}
