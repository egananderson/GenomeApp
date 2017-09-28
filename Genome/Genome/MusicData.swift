//
//  MusicData.swift
//  Genome
//
//  Created by Egan Anderson on 4/23/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import Foundation

class MusicData: NSObject {
    let musicDataType: MusicDataType
    var song: String?
    var artist: String
    var album: String?
    var time: Date?
    
    init(musicDataType: MusicDataType, artist: String, song: String?, album: String?, time: Date?) {
        self.musicDataType = musicDataType
        self.artist = artist
        self.song = song
        self.album = album
        self.time = time
    }
}

enum MusicDataType {
    case topTrack
    case topArtist
    case recentlyPlayed
}
