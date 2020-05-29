//
//  Url.swift
//  musicPlayer
//
//  Created by Gor on 4/18/20.
//  Copyright © 2020 user1. All rights reserved.
//

import Foundation

let SONGS_URL = "https://itunes.apple.com/search?term="

class DataService {
    
    
    static let instance = DataService()
    
    func getTracks (searchRequest: String, complition: @escaping ([Track])->()) {
        var tracks = [Track]()
        let searchString = searchRequest.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "\(SONGS_URL)\(searchString)")
        let session = URLSession.shared
        guard url != nil else { return }
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let trackResults = json["results"] as? NSArray {
                        for track in trackResults {
                            if let trackInfo = track as? [String: AnyObject] {
                                guard let trackName = trackInfo["trackName"] as? String else {return}
                                guard let artistName = trackInfo["artistName"] as? String else {return}
                                guard let primaryGenreName = trackInfo["primaryGenreName"] as? String else {return}
                                guard let previewUrl = trackInfo["previewUrl"] as? String else {return}
                                guard let artworkUrl100 = trackInfo["artworkUrl100"] as? String else {return}
                                guard let collectionName = trackInfo["collectionName"] as? String else {return}
                                guard let trackTimeMillis = trackInfo["trackTimeMillis"] as? Int else {return}
                                let trackInstance = Track(trackName: trackName, artistName: artistName , primaryGenreName: primaryGenreName, previewUrl: previewUrl , artworkUrl100: artworkUrl100 , collectionName: collectionName , trackTimeMillis: trackTimeMillis)
                                tracks.append(trackInstance)
                            }
                        }
                        complition(tracks)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            if error != nil {
                print(error!.localizedDescription)
            }
        }.resume()
    }
}
