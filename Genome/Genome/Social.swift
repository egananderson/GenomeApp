//
//  Social.swift
//  Genome
//
//  Created by Jordan Davis on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Social: NSObject {
    
    var posts:[Post]?
    var inspirationalPeople:[String]?
    
    override init(){
        super.init()
        
        posts = []
        inspirationalPeople = []
        
        self.getSocial(){(success, error)->Void in
            if(!success){
                print("Error Getting Social")
            } else {
                print("Social completed successfully")
            }
        }
    }
    
    
    private func getSocial(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/social?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=posts,inspirational_people") {
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
                    print("Social statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToSocial(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object Social")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToSocial(json: [String: Any] ) {
        if let post = json["posts"] as? [[String: Any]]{
            for p in post {
                let newPost = Post()
                
                if let story = p["story"] as? String{
                    newPost.story = story
                }
                
                if let mess = p["message"] as? String{
                    newPost.message = mess
                }
                
                if let time = p["timestamp"] as? String{
                    newPost.timestamp = time
                }
                
                self.posts?.append(newPost)
            }
        }
        
        if let people = json["inspirational_people"] as? [String]{
            for p in people {
                self.inspirationalPeople?.append(p)
            }
            
        }
        
    }
    
}

public class Post:NSObject {
    var story: String?
    var message: String?
    var timestamp: String?
}
