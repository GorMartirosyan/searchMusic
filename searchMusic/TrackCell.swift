//
//  TrackCell.swift
//  musicPlayer
//
//  Created by Gor on 4/18/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
        
    override func prepareForReuse() {
        songImage.image = nil
        songName.text = " "
        artistName.text = " "
        genre.text = " "
        timeLabel.text = " "
    }
    
    func setUp(with track: Track) {
        let trackSeconds = NSInteger(track.trackTimeMillis / 1000)
        let seconds = trackSeconds % 60
        let minutes = (trackSeconds / 60) % 60
        let formattedDuration = NSString(format: "%0.2d:%0.2d",minutes,seconds)
        
        timeLabel.text = String(formattedDuration)
        songName.text = track.trackName
        artistName.text = track.artistName
        genre.text = track.primaryGenreName
    }
    
    func loadImage(with track: Track) {
        let urlString =  track.artworkUrl100
        if self.songImage.image == nil { self.songImage.image = .none }
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {return}
            DispatchQueue.main.async(execute: { () -> Void in
                guard let data = data else {return}
                let image = UIImage(data: data)
                self.songImage.image = image
            })
        }).resume()
    }
}
