//
//  track.swift
//  musicPlayer
//
//  Created by Gor on 4/18/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit

class Track {
    var trackName: String
    var artistName: String
    var primaryGenreName: String
    var previewUrl: String
    var artworkUrl100: String
    var collectionName: String
    var trackTimeMillis: Int
    
    init(trackName : String,artistName: String, primaryGenreName: String, previewUrl: String, artworkUrl100: String, collectionName: String, trackTimeMillis: Int){
        self.trackName = trackName
        self.artistName = artistName
        self.primaryGenreName = primaryGenreName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.collectionName = collectionName
        self.trackTimeMillis = trackTimeMillis
    }
}
