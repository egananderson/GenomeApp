//
//  Entertainment.swift
//  Genome
//
//  Created by Jordan Davis on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class Entertainment: NSObject {
    
    var books:[String]?
    var movies:[String]?
    var television:[String]?
    var music:[String]?
    var topArtists:[String]?
    var topTracks:[MusicTrack]?
    var recentlyPlayedTracks:[MusicTrack]?
    
    var subCategories:[EntertainmentCategory]?

    
    override init(){
        super.init()
        
        books = []
        movies = []
        television = []
        music = []
        topArtists = []
        topTracks = []
        recentlyPlayedTracks = []
        
        self.getEntertainment(){(success, error)->Void in
            if(!success){
                print("Error Getting Entertainment")
            } else {
                print("Entertainment completed successfully")
                let userController = UserController.sharedInstance
                userController.updateEntertainment(entertainment: self)
            }
        }
    }
    
    
    private func getEntertainment(completionHandler: @escaping (Bool, Error?) -> Void){
        let user = UserController.sharedInstance
        if let urlString = URL(string:"http://35.165.224.147:60000/genome/entertainment?UserToken=\(user.currentUser?.userID ?? "NoToken")&AppToken=CTRL-ALT-DATA-GENOME&Scopes=books,movies,television,music,top_artists,top_tracks,recently_played_tracks") {
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
                    print("entertainment statusCode should be 200, but is \(httpStatus.statusCode)")
                    completionHandler(false, error)
                    return
                }
                
                do{ // Parse Json Object and Get User Token
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                        self.jsonToEntertainment(json: json)
                    }
                    completionHandler(true, nil)
                    return
                }catch{
                    print("Unable to parse json object entertainment")
                }
                completionHandler(false, error)
                return
            }
            task.resume()
            
        }
        
    }
    
    private func jsonToEntertainment(json: [String: Any] ) {
        if let book = json["books"] as? [String]{
            if(!book.isEmpty) {
                subCategories?.append(EntertainmentCategory.books)
                for b in book {
                    books?.append(b)
                }
            }
        }
        
        if let mov = json["movies"] as? [String]{
            if(!mov.isEmpty) {
                subCategories?.append(EntertainmentCategory.movies)
                for m in mov {
                    movies?.append(m)
                }
            }
        }
        
        if let tv = json["television"] as? [String]{
            if(!tv.isEmpty) {
                subCategories?.append(EntertainmentCategory.television)
                for t in tv {
                    television?.append(t)
                }
            }

        }
        
        if let tunes = json["music"] as? [String]{
            if(!tunes.isEmpty) {
                subCategories?.append(EntertainmentCategory.music)
                for t in tunes {
                    music?.append(t)
                }
            }

        }
        
        if let favArtists = json["top_artists"] as? [String]{
            if(!favArtists.isEmpty) {
                subCategories?.append(EntertainmentCategory.topArtists)
                for fav in favArtists {
                    topArtists?.append(fav)
                }
            }

        }
        
        if let favTracks = json["top_tracks"] as? [[String: Any]]{
            if(!favTracks.isEmpty){
                subCategories?.append(EntertainmentCategory.topTracks)
                for track in favTracks {
                    
                    let musicTrack = MusicTrack()
                    
                    if let title = track["Title"] as? String{
                        musicTrack.title = title
                    }
                    
                    if let artist = track["Artist"] as? String{
                        musicTrack.artist = artist
                    }
                    
                    if let album = track["Album"] as? String{
                        musicTrack.album = album
                    }
                    
                    topTracks?.append(musicTrack)
                }
            }
        }
        
        if let recentTracks = json["recently_played_tracks"] as? [[String: Any]]{
            if(!recentTracks.isEmpty) {
                subCategories?.append(EntertainmentCategory.recentlyPlayedTracks)
                for track in recentTracks {
                    let musicTrack = MusicTrack()
                    
                    if let title = track["Title"] as? String{
                        musicTrack.title = title
                    }
                    
                    if let artist = track["Artist"] as? String{
                        musicTrack.artist = artist
                    }
                    
                    if let album = track["Album"] as? String{
                        musicTrack.album = album
                    }
                    
                    if let time = track["DatePlayed"] as? String{
                        musicTrack.timestamp = time
                    }
                    
                    recentlyPlayedTracks?.append(musicTrack)
                }
            }
        }
    }
    
    enum EntertainmentCategory {
        case movies
        case television
        case music
        case books
        case topTracks
        case topArtists
        case recentlyPlayedTracks
    }

}

public class MusicTrack {
    var title: String?
    var artist: String?
    var album: String?
    var timestamp: String?
}
