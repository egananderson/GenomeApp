//
//  Sports.swift
//  Genome
//
//  Created by Jordan Davis on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Sports: NSObject {
    
    var favoriteAthletes:[String]?
    var favoriteTeams:[String]?
    
    override init(){
        super.init()
        
        favoriteAthletes = []
        favoriteTeams = []
        
        self.getSports(){(success, error)->Void in
            if(!success){
                print("Error Getting Sports")
            } else {
                print("Sports completed successfully")
                let userController = UserController.sharedInstance
                userController.updateSports(sports: self)
            }
        }
    }
    
    
    private func getSports(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/sports?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=athletes,sports_teams") {
            var request = URLRequest(url: urlString)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    //check for fundamental networking error
                    completionHandler(false, error)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                    // check for http errors
                    print("Sports statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToSports(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object Sports")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToSports(json: [String: Any] ) {
        if let athlete = json["athletes"] as? [String]{
            for a in athlete {
                self.favoriteAthletes?.append(a)
            }
        }
        
        if let teams = json["sports_teams"] as? [String]{
            for t in teams {
                self.favoriteTeams?.append(t)
            }
            
        }
    }
    
}
