//
//  Experience.swift
//  Genome
//
//  Created by Jordan Davis on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Experience: NSObject {
    
    var work:[Work]?
    var education:[Education]?
    
    override init(){
        super.init()
        
        work = []
        education = []
        
        self.getExperience(){(success, error)->Void in
            if(!success){
                print("Error Getting Experience")
            } else {
                print("Experience completed successfully")
            }
        }
    }
    
    
    private func getExperience(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/experience?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=work,education") {
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
                    print("Experience statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToExperience(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object Experience")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToExperience(json: [String: Any] ) {
        if let job = json["work"] as? [[String: Any]]{
            for j in job {
                let w = Work()
                if let business_name = j["name"] as? String{
                    w.businessName = business_name
                }
                
                if let pos = j["position"] as? String{
                    w.position = pos
                }
                
                if let job_description = j["description"] as? String{
                    w.about = job_description
                }
                
                if let start = j["startDate"] as? String{
                    w.startDate = start
                }
                
                
                if let end = j["endDate"] as? String{
                    w.endDate = end
                }
                
                if let location = j["location"] as? [String:Any] {
                    if let cty = location["city"] as? String{
                        w.city = cty
                    }
                    if let st = location["state"] as? String{
                        w.state = st
                    }
                    if let cntry = location["country"] as? String{
                        w.country = cntry
                    }
                }
                
                self.work?.append(w)
            }
        }
        
        if let edu = json["education"] as? [[String: Any]]{
            for eduOBJ in edu {
                let e = Education()
                if let school_name = eduOBJ["school"] as? String{
                    e.school = school_name
                }
                
                if let y = eduOBJ["year"] as? String{
                    e.year = y
                }
                
                if let majors = eduOBJ["concentrations"] as? [String]{
                    for m in majors {
                        e.concentrations?.append(m)
                    }
                }
                
                if let deg = eduOBJ["degree"] as? String{
                    e.degree = deg
                }
                
                
                self.education?.append(e)
            }

        }
        
    }
    
}

public class Education:NSObject {
    var school: String?
    var year: String?
    var degree: String?
    var concentrations: [String]?
}

public class Work:NSObject {
    var businessName: String?
    var position: String?
    var about: String?
    var startDate: String?
    var endDate: String?
    var city: String?
    var state: String?
    var country: String?
}
