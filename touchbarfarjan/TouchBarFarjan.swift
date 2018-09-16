//
//  TouchBarFarjan.swift
//  touchbarfarjan
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Aero Deko. All rights reserved.
//

import Cocoa
import AVFoundation

class TouchBarFarjan {
    let audioPlayer: AVAudioPlayer

    init() {
        print("\(Bundle.main.bundlePath)")
        
        if let trackUrl = Bundle.main.url(forResource: "farjan", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
            self.audioPlayer.numberOfLoops = 9999999999
        } else {
            abort()
        }
        
        self.audioPlayer.prepareToPlay()
    }
    
    func start() {
        self.audioPlayer.play()
    }
}
