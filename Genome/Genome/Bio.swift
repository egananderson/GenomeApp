//
//  Bio.swift
//  Genome
//
//  Created by Jordan Davis on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Bio: NSObject {
    
    var firstName:String?
    var middleName:String?
    var lastName:String?
    var fullName:String?
    var nameFormat:String?
    var shortName:String?
    var gender:String?
    var email:String?
    var birthday:String?
    var about:String?
    var hometown:String?
    var currentLocation:String?
    var relationshipStatus:String?
    var currency:String?
    var religion:String?
    var politics:String?
    var website:String?
    var quotes:String?
    var languages:[String]?
    
    var subCategories:[BioCategory]?
    
    override init(){
        super.init()
        
        languages = []
        
        self.getBio(){(success, error)->Void in
            if(!success){
                print("Error Getting Bio")
            } else {
                print("Bio completed successfully")
            }
        }
    }


    private func getBio(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/bio?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=name,gender,email,birthday,about,hometown,current_location,relationship_status,currency,religion_politics,website,quotes,languages") {
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
                    print("bio statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToBio(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object bio")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToBio(json: [String: Any] ) {
        subCategories = [BioCategory]()
        
        if let first = json["first_name"] as? String{
            firstName = first
            subCategories?.append(BioCategory.firstName)
        }
        
        if let mid = json["middle_name"] as? String{
            middleName = mid
            subCategories?.append(BioCategory.middleName)
        }
        
        if let last = json["last_name"] as? String{
            lastName = last
            subCategories?.append(BioCategory.lastName)
        }
        
        if let full = json["full_name"] as? String{
            fullName = full
            subCategories?.append(BioCategory.fullName)
        }
        
        if let format = json["format"] as? String{
            nameFormat = format
            subCategories?.append(BioCategory.nameFormat)
        }
        
        if let short = json["short_name"] as? String{
            shortName = short
            subCategories?.append(BioCategory.shortName)
        }
        
        if let gen = json["gender"] as? String{
            gender = gen
            subCategories?.append(BioCategory.gender)
        }
        
        if let mail = json["email"] as? String{
            email = mail
            subCategories?.append(BioCategory.email)
        }
        
        if let bday = json["birthday"] as? String{
            birthday = bday
            subCategories?.append(BioCategory.birthday)
        }
        
        if let bout = json["about"] as? String{
            about = bout
            subCategories?.append(BioCategory.about)
        }
        
        if let town = json["hometown"] as? String{
            hometown = town
            subCategories?.append(BioCategory.hometown)
        }
        
        if let current = json["curren_location"] as? String{
            currentLocation = current
            subCategories?.append(BioCategory.currentLocation)
        }
        
        if let rstatus = json["relationship_status"] as? String{
            relationshipStatus = rstatus
            subCategories?.append(BioCategory.relationshipStatus)
        }
        
        if let curr = json["currency"] as? String{
            currency = curr
            subCategories?.append(BioCategory.currency)
        }
        
        if let relig = json["religion"] as? String{
            religion = relig
            subCategories?.append(BioCategory.religion)
        }
        
        if let pol = json["politics"] as? String{
            politics = pol
            subCategories?.append(BioCategory.politics)
        }
        
        if let web = json["website"] as? String{
            website = web
            subCategories?.append(BioCategory.website)
        }
        
        if let quote = json["quotes"] as? String{
            quotes = quote
            subCategories?.append(BioCategory.quotes)
        }
        
        if let lang = json["languages"] as? [String]{
            if lang.count == 0 {
                return
            }
            for l in lang{
                languages?.append(l)
            }
            subCategories?.append(BioCategory.languages)
        }
        
    }
    
    enum BioCategory {
        case firstName
        case middleName
        case lastName
        case fullName
        case nameFormat
        case shortName
        case gender
        case email
        case birthday
        case about
        case hometown
        case currentLocation
        case relationshipStatus
        case currency
        case religion
        case politics
        case website
        case quotes
        case languages
    }
}
