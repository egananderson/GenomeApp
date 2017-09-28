//
//  Location.swift
//  Genome
//
//  Created by Jordan Davis on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Location: NSObject {
    
    var taggedPlaces:[Place]?
    
    override init(){
        super.init()
        
        taggedPlaces = []
        
        self.getLocations(){(success, error)->Void in
            if(!success){
                print("Error Getting Locations")
            } else {
                print("Locations completed successfully")
            }
        }
    }
    
    
    private func getLocations(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/location?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=tagged_places") {
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
                    print("Locations statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToLocations(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object Locations")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToLocations(json: [String: Any] ) {
        if let places = json["tagged_places"] as? [[String: Any]]{
            for place in places {
                let newPlace = Place()
                
                if let name = place["name"] as? String{
                    newPlace.name = name
                }
                
                if let country = place["country"] as? String{
                    newPlace.country = country
                }
                
                if let state = place["state"] as? String{
                    newPlace.state = state
                }
                
                if let city = place["city"] as? String{
                    newPlace.city = city
                }
                
                if let lat = place["latitude"] as? String{
                    newPlace.latitude = lat
                }
                
                if let lon = place["longitude"] as? String{
                    newPlace.longitude = lon
                }
                
                if let zip = place["zip"] as? String{
                    newPlace.zip = zip
                }
                
                if let time = place["timestamp"] as? String{
                    newPlace.timestamp = time
                }
                
                self.taggedPlaces?.append(newPlace)
            }
        }
    }
    
}

public class Place:NSObject {
    var name: String?
    var country: String?
    var state: String?
    var city: String?
    var latitude: String?
    var longitude: String?
    var zip: String?
    var timestamp: String?
}
