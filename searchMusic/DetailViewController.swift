//
//  ViewController.swift
//  loadMusicAnimation
//
//  Created by Gor on 3/28/20.
//  Copyright © 2020 user1. All rights reserved.
//

import UIKit
import AVFoundation


class DetailViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var reverseBackground: UIView!
    @IBOutlet var playPauseBackground: UIView!
    @IBOutlet var forwardBackground: UIView!
    @IBOutlet var reverseButton: UIButton!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var artworkArray = [String]()
    var previewArray = [String]()
    var player = AVAudioPlayer()
    var cellNumber = Int()
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        isPlaying = false
        image()
        self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.albumImageView.layer.cornerRadius = 8
        
        reverseBackground.layer.cornerRadius = 35.0
        reverseBackground.clipsToBounds = true
        reverseBackground.alpha = 0.0
        
        playPauseBackground.layer.cornerRadius = 35.0
        playPauseBackground.clipsToBounds = true
        playPauseBackground.alpha = 0.0
        
        forwardBackground.layer.cornerRadius = 35.0
        forwardBackground.clipsToBounds = true
        forwardBackground.alpha = 0.0
        
        Timer.scheduledTimer(timeInterval: 0.01,
                             target: self,
                             selector: #selector(self.updateTime),
                             userInfo: nil,
                             repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player = .init()
    }
    
    func convertImageUrl(url: URL) -> URL {
        let urlString = url.absoluteString.replacingOccurrences(of: "100x100",with: "300x300")
        return URL(string: urlString)!
    }
    
    func image() {
        if cellNumber < 0 || cellNumber == previewArray.count {cellNumber = 0}
        let imageUrl = URL(string: artworkArray[cellNumber])
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: self.convertImageUrl(url: imageUrl!)) {
                DispatchQueue.main.async {
                    self.albumImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    func showIndicator(){
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideIndicator() {
        alert.dismiss(animated: false, completion: nil)
    }
    
    func loadMusic(completion: (_ completed: Bool) -> Void){
        if cellNumber < 0 || cellNumber > previewArray.count { cellNumber = 0 }
        let fileURL = URL(string:previewArray[cellNumber])
        let songData = try! Data(contentsOf: fileURL!)
        self.player = try! AVAudioPlayer(data: songData)
        
        player.delegate = self
        player.prepareToPlay()
        
        completion(true)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
    @objc func updateTime() {
        let currentTime = Int(player.currentTime)
        let duration = Int(player.duration)
        
        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        let totalMinutes = duration/60
        var totalSeconds = duration - totalMinutes/60
        if totalMinutes > 0 {
            totalSeconds = totalSeconds - 60 * totalMinutes
        }
        
        slider.value = Float(player.currentTime)
        slider.maximumValue = Float(player.duration)
        timeLabel.text = String(format: "%02d:%02d", minutes,seconds) as String
        totalTimeLabel.text = String(format: "%02d:%02d", totalMinutes,totalSeconds) as String
    }
    
    var isPlaying: Bool = true {
        didSet {
            if isPlaying {
                if player.rate != 0 {
                    player.play()
                } else {
                    showIndicator()
                    DispatchQueue.global().async {
                        self.loadMusic { (completed) in
                            DispatchQueue.main.async {
                                self.player.play()
                                self.hideIndicator()
                            }
                        }
                    }
                }
                playPauseButton.setImage(UIImage(named:
                    "pause")!, for: .normal)
            } else {
                player.pause()
                playPauseButton.setImage(UIImage(named:
                    "play")!, for: .normal)
            }
        }
    }
    
    @IBAction func playPauseButtonTapped() {
        if isPlaying {
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.albumImageView.transform = CGAffineTransform.identity})
        }
        isPlaying.toggle()
    }
    
    @IBAction func touchedDown(_ sender: UIButton) {
        let buttonBackground: UIView
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            buttonBackground.alpha = 0.3
            sender.transform = CGAffineTransform(scaleX: 0.8, y:0.8)
        }
    }
    
    @IBAction func touchedUpInside(_ sender: UIButton) {
        var buttonBackground: UIView
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            buttonBackground.alpha = 0.0
            buttonBackground.transform = CGAffineTransform(scaleX:1.2, y: 1.2)
            sender.transform = CGAffineTransform.identity
        }) { (_) in
            buttonBackground.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func changeAudioTime(_ sender: Any) {
        if isPlaying == true {
            player.stop()
            player.currentTime = TimeInterval(slider.value)
            player.prepareToPlay()
            player.play()
        }else{
            player.currentTime = TimeInterval(slider.value)
            player.prepareToPlay()
        }
    }
    
    @IBAction func reverseSong(_ sender: Any) {
        isPlaying = false
        cellNumber -= 1
        self.player = .init()
        self.albumImageView.image = .none
        viewDidLoad()
    }
    
    @IBAction func forwardSong(_ sender: Any) {
        isPlaying = false
        cellNumber += 1
        self.player = .init()
        self.albumImageView.image = .none
        viewDidLoad()
    }
}
