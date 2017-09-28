//
//  UserController.swift
//  Genome
//
//  Created by Egan Anderson on 4/4/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class UserController: NSObject {
    
    var host = "http://35.165.224.147:60000/"
    //var host = "http://155.99.172.240:60000/"
    //var host = "http://localhost:60000/"
    
    let genomeAppToken = "CTRL-ALT-DATA-GENOME"
    
    var currentUser: User?
    var currentDataCategory: DataCategory?
    var currentAccount: String?
    var currentApp: String?
    
    //persistant data
    var loggedIn = false
    var oauthTokens = [String : [String : String]]()
    
    // the singleton for our person controller
    static let sharedInstance = UserController()
    
    fileprivate override init() {}
    
    //MARK: - DATA PERSISTENCE
    
    func save(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(self.currentUser?.userID, forKey: "currentUserId")
        userDefaults.set(self.loggedIn, forKey: "loggedIn")
        userDefaults.set(self.oauthTokens, forKey: "authTokens")
        userDefaults.synchronize()
    }
    
    func load(){
        let userDefaults = UserDefaults.standard
        self.loggedIn = userDefaults.bool(forKey: "loggedIn")
        self.oauthTokens = (userDefaults.dictionary(forKey: "authTokens") != nil) ? userDefaults.dictionary(forKey: "authTokens") as! [String : [String : String]] : [String : [String : String]]()
        
        if (self.loggedIn) {
            let userID = userDefaults.string(forKey: "currentUserId")
            self.currentUser = User(userID: userID!)
            
            if(self.oauthTokens[userID!] != nil) {
                for account in (self.oauthTokens[userID!]?.keys)! {
                    self.currentUser?.accounts?.append(account)
                }
            }
        }

        userDefaults.synchronize()
    }
    
     //MARK: - HARD CODED METHODS
    
    func addDataCategories() {
        // call this method using "spotifyLoginSuccessfull" notification
        // use scopes from the service to add categories
        self.currentUser?.dataCategories?.append(DataCategory(name: "Personal Bio", value: ">"))
        self.currentUser?.dataCategories?.append(DataCategory(name: "Location", value: ">"))
        self.currentUser?.dataCategories?.append(DataCategory(name: "Entertainment", value: ">"))
        self.currentUser?.dataCategories?.append(DataCategory(name: "Social Media", value: ">"))
        self.currentUser?.dataCategories?.append(DataCategory(name: "Experience", value: ">"))
        self.currentUser?.dataCategories?.append(DataCategory(name: "Sports", value: ">"))
        self.currentDataCategory = self.currentUser?.dataCategories?[0]
        
    }
    
    func addSubDataCategories() {
        // call this method using "spotifyLoginSuccessfull" notification
        // use scopes from the service to add categories
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Top Tracks", value: ">"))
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Top Artists", value: ">"))
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Recently Played Tracks", value: ">"))
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Books", value: ">"))
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Movies", value: ">"))
        self.currentUser?.dataCategories?[2].subCategories?.append(DataCategory(name: "Television", value: ">"))
        
        self.currentUser?.dataCategories?[5].subCategories?.append(DataCategory(name: "Favorite Athletes", value: ">"))
        self.currentUser?.dataCategories?[5].subCategories?.append(DataCategory(name: "Favorite Teams", value: ">"))
        
        self.updateMusic(){(success)->Void in
            if(!success){//do somethin?
            }
        }
        
    }
    
    func updateMusic(completionHandler: @escaping (Bool) -> Void){
        
        self.currentUser?.bio = Bio()
        self.currentUser?.location = Location()
        self.currentUser?.sports = Sports()
        self.currentUser?.experience = Experience()
        self.currentUser?.entertainment = Entertainment()
        self.currentUser?.social = Social()
        
        if self.oauthTokens[(self.currentUser?.userID)!]?["spotify"] == nil {
            return
        } else {
            let service = "spotify"
            let token = (self.oauthTokens[(self.currentUser?.userID)!]?[service]!)!
            AccountController.sharedInstance.sendTokenToServer(host: self.host, token: token, service: service)
        }
        
        completionHandler(true)
    }
    
    func updateEntertainment(entertainment: Entertainment) {
        self.addUsersTopTracks(entertainment: entertainment)
        self.addUsersTopArtists(entertainment: entertainment)
        self.addUsersRecentlyPlayedTracks(entertainment: entertainment)
        self.addUsersBooks(entertainment: entertainment)
        self.addUsersMovies(entertainment: entertainment)
        self.addUsersTelevision(entertainment: entertainment)
    }
    
    func updateSports(sports: Sports) {
        self.addUsersFavAthletes(sports: sports)
        self.addUsersFavTeams(sports: sports)
    }
    
    func addPermissionsInfo(completionHandler: @escaping () -> Void){
        var completed = 0
        self.addUsersConnectedAccounts(){(success,error) -> () in
            if(!success){
                print(error as Any)
            }
            completed += 1
            if(completed == 2){
                completionHandler()
            }
        }
            
        self.addUsersConnectedApps(){(success,error) -> () in
            if(!success){
                print(error as Any)
            }
            completed += 1
            if(completed == 2){
                completionHandler()
            }
        }

    }
    
    
    //MARK: - AUTHENTICATION / LOGIN / LOGOUT
    
    func logout() {
        self.loggedIn = false
        OAuthIOModal().clearCache()
        self.save()
    }
    
    func registerNewUser(email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: host + "genome/auth/register")!)
        request.httpMethod = "POST"
        let postString = "{\"UserEmail\":\"" + email + "\", \"UserPassword\":\"" + password + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 201) {
                // check for http errors
                print("registration statusCode should be 201, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let token = json["UserToken"] as? String {
                        self.load()
                        self.currentUser = User(userID: token)
                        self.loggedIn = true
                        self.save()
                        completionHandler(true, nil)
                        return
                    }
                }
            }catch{
                print("Unable to parse json object durring registration")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func loginUser(email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: host + "genome/auth/login")!)
        request.httpMethod = "POST"
        let postString = "{\"UserEmail\":\"" + email + "\", \"UserPassword\":\"" + password + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("login statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let token = json["UserToken"] as? String {
                        self.load()
                        self.currentUser = User(userID: token)
                        self.loggedIn = true
                        self.save()
                        self.updateMusic(){(success)->() in
                            if(!success){//do somethin?
                            }
                        }
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json object durring login")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    func loginUserFromFacebook(email: String, fbToken: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: host + "genome/auth/login_fb")!)
        request.httpMethod = "POST"
        let postString = "{\"UserEmail\":\"" + email + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                self.registerNewUser(email: email, password: ""){ (success, error) -> () in
                    if (success) {
                        self.load()
                        var tokens = self.oauthTokens[(self.currentUser?.userID)!]
                        if (tokens == nil) {
                            tokens = [:]
                        }
                        tokens!["facebook"] = fbToken
                        self.oauthTokens[(self.currentUser?.userID)!] = tokens!
                        AccountController.sharedInstance.sendTokenToServer(host: self.host, token: fbToken, service: "facebook")
                        self.save()
                       completionHandler(true, NSError(domain: "", code: 300, userInfo: nil))
                    } else {
                       print("Error durring FB registration " + error.debugDescription)
                       completionHandler(false, error)
                    }
                }
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let userToken = json["UserToken"] as? String {
                        self.load()
                        self.currentUser = User(userID: userToken)
                        self.loggedIn = true
                        var tokens = self.oauthTokens[(self.currentUser?.userID)!]
                        if (tokens == nil) {
                            tokens = [:]
                        }
                        tokens!["facebook"] = fbToken
                        self.oauthTokens[(self.currentUser?.userID)!] = tokens!
                        AccountController.sharedInstance.sendTokenToServer(host: self.host, token: fbToken, service: "facebook")
                        self.save()
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json object durring login")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    
    //MARK: - MUSIC DATA REQUESTS
    
    private func addUsersTopTracks(entertainment:Entertainment){
        if let trackList = entertainment.topTracks{
            self.currentUser?.dataCategories?[2].subCategories?[0].data = []
            for track in trackList {
                let title = track.title
                let artist = track.artist
                let album = track.album
                
                self.currentUser?.dataCategories?[2].subCategories?[0].data.append(MusicData(musicDataType: .topTrack, artist: artist!, song: title, album: album, time: nil))
            }
        }
    }
    
    private func addUsersTopArtists(entertainment:Entertainment){
        self.currentUser?.dataCategories?[2].subCategories?[1].data = []
        if let artists = entertainment.topArtists{
            for name in artists {
                self.currentUser?.dataCategories?[2].subCategories?[1].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }

    }
    
    private func addUsersRecentlyPlayedTracks(entertainment:Entertainment){
        if let trackList = entertainment.recentlyPlayedTracks{
            self.currentUser?.dataCategories?[2].subCategories?[2].data = []
            for track in trackList {
                let title = track.title
                let artist = track.artist
                let album = track.album
                let dateString = track.timestamp
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
                
                self.currentUser?.dataCategories?[2].subCategories?[2].data.append(MusicData(musicDataType: .topTrack, artist: artist!, song: title, album: album, time: dateFormatter.date(from: dateString!)))
                
            }
        }
    }
    
    private func addUsersBooks(entertainment:Entertainment){
        self.currentUser?.dataCategories?[2].subCategories?[3].data = []
        if let books = entertainment.books{
            for name in books {
                self.currentUser?.dataCategories?[2].subCategories?[3].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }
        
    }
    
    private func addUsersMovies(entertainment:Entertainment){
        self.currentUser?.dataCategories?[2].subCategories?[4].data = []
        if let movie = entertainment.movies{
            for name in movie {
                self.currentUser?.dataCategories?[2].subCategories?[4].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }
        
    }
    
    private func addUsersTelevision(entertainment:Entertainment){
        self.currentUser?.dataCategories?[2].subCategories?[5].data = []
        if let tv = entertainment.television{
            for name in tv {
                self.currentUser?.dataCategories?[2].subCategories?[5].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }
        
    }
    
    //MARK: - Sports DATA REQUESTS
    
    private func addUsersFavAthletes(sports:Sports){
        if let athletes = sports.favoriteAthletes{
            self.currentUser?.dataCategories?[5].subCategories?[0].data = []
            for name in athletes {
                self.currentUser?.dataCategories?[5].subCategories?[0].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }
    }
    
    private func addUsersFavTeams(sports:Sports){
        self.currentUser?.dataCategories?[5].subCategories?[1].data = []
        if let team = sports.favoriteTeams{
            for name in team {
                self.currentUser?.dataCategories?[5].subCategories?[1].data.append(MusicData(musicDataType: .topArtist, artist: name, song: nil, album: nil, time: nil))
            }
        }
        
    }
    
    
    //MARK: - DEFAULT ACCOUNT SETTINGS
    
    
    private func addUsersConnectedAccounts(completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: self.host + "genome/permissions/accounts")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + (self.currentUser?.userID)! + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/accounts statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let accountList = json["Accounts"] as? [String]{
                        self.currentUser?.accounts = []
                        for accountName in accountList {
                            self.currentUser?.accounts?.append(accountName)
                            self.addAllPermissionsForAccount(accountName: accountName)
                        }
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json for connected accounts")
            }
            completionHandler(false, nil)
            return
        }
        task.resume()
    }
    
    
    private func addUsersConnectedApps(completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: host + "genome/permissions/apps")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + (self.currentUser?.userID)! + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/apps statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let appsList = json["Apps"] as? [String]{
                        self.currentUser?.apps = []
                        for appName in appsList {
                            self.currentUser?.apps?.append(appName)
                            self.addAllScopesForApp(appName: appName)
                        }
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json for connected apps")
            }
            completionHandler(false, error)
            return
        }
        task.resume()
    }
    
    
    private func addAllPermissionsForAccount(accountName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/account/services")!)
        request.httpMethod = "POST"
        let postString = "{\"AccountName\":\"" + accountName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/accounts/services statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let permissions = json["Services"] as? [String]{
                        self.currentUser?.permissionsForAccount?[accountName] = permissions
                        for p in permissions {
                            self.currentUser?.permissionStatus?[accountName] = [p:false]
                        }
                    }
                }
            }catch{
                print("Unable to parse json for account permissions")
            }
            return
        }
        task.resume()
    }
    
    
    private func addAllScopesForApp(appName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/app/scopes")!)
        request.httpMethod = "POST"
        let postString = "{\"AppName\":\"" + appName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/app/scopes statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let scopes = json["Scopes"] as? [String]{
                        self.currentUser?.scopesForApp?[appName] = scopes
                        for s in scopes {
                            self.currentUser?.scopesStatus?[appName] = [s:false]
                        }
                    }
                }
            }catch{
                print("Unable to parse json for app scopes")
            }
            return
        }
        task.resume()
    }
    
    
    //MARK: - MODIFY USER ACCOUNT SETTINGS
    
    
    func getUserAllowedPermissionsForAccount(userToken: String, accountName: String, completionHandler: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: URL(string: host + "genome/permissions/account/services/userAllowed")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\",\"AccountName\":\"" + accountName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/accounts/services/userAllowed statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let permissions = json["AllowedServices"] as? [String]{
                        //First set all to false
                        for name in (self.currentUser?.permissionStatus?[accountName]?.keys)! {
                            self.currentUser?.permissionStatus?[accountName]?[name] = false
                        }
                        //update allowed scopes to true
                        for name in permissions {
                            self.currentUser?.permissionStatus?[accountName]?[name] = true
                        }
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json for account permissions")
            }
            completionHandler(false, nil)
            return
        }
        task.resume()
    }
    
    
    
    func getUserAllowedScopesForApp(userToken: String, appName: String, completionHandler: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: URL(string: host + "genome/permissions/app/scopes/userAllowed")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\" , \"AppName\":\"" + appName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //check for fundamental networking error
                completionHandler(false, error)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/app/scopes/userAllowed statusCode should be 200, but is \(httpStatus.statusCode)")
                completionHandler(false, error)
                return
            }
            
            do{ // Parse Json Object and Get User Token
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let scopes = json["AllowedScopes"] as? [String]{
                        //First set all to false
                        for name in (self.currentUser?.scopesStatus?[appName]?.keys)! {
                            self.currentUser?.scopesStatus?[appName]?[name] = false
                        }
                        //update allowed scopes to true
                        for name in scopes {
                            self.currentUser?.scopesStatus?[appName]?[name] = true
                        }
                    }
                }
                completionHandler(true, nil)
                return
            }catch{
                print("Unable to parse json for app scopes")
            }
            completionHandler(false, nil)
            return
        }
        task.resume()
    }
    
    
    func removeUserAllowedPermissionsForAccount(userToken: String, accountName: String, permissionName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/account/services/removeUser")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\",\"AccountName\":\"" + accountName + "\",\"PermissionName\":\"" + permissionName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/accounts/services/removeUser statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }

            return
        }
        task.resume()
    }
    
    
    
    func removeUserAllowedScopesForApp(userToken: String, appName: String, scopeName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/app/scopes/removeUser")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\",\"AppName\":\"" + appName + "\",\"ScopeName\":\"" + scopeName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/app/scopes/removeUser statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            return
        }
        task.resume()
    }
    
    func addUserAllowedPermissionsForAccount(userToken: String, accountName: String, permissionName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/account/services/addUser")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\",\"AccountName\":\"" + accountName + "\",\"PermissionName\":\"" + permissionName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/accounts/services/addUser statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            return
        }
        task.resume()
    }
    
    
    
    func addUserAllowedScopesForApp(userToken: String, appName: String, scopeName: String){
        var request = URLRequest(url: URL(string: host + "genome/permissions/app/scopes/addUser")!)
        request.httpMethod = "POST"
        let postString = "{\"UserToken\":\"" + userToken + "\",\"AppName\":\"" + appName + "\",\"ScopeName\":\"" + scopeName + "\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200) {
                // check for http errors
                print("permissions/app/scopes/addUser statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            return
        }
        task.resume()
    }
    
   
}

