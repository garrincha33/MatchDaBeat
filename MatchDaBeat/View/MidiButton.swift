//
//  MidiButton.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit
import AVFoundation

public class MidiButton : UIView, UIGestureRecognizerDelegate {

    private var sound : Sounds!
    private var players = [AVAudioPlayer]()

    public required init(sound: Sounds) {
        self.sound = sound
        super.init(frame: .zero)
        //initializing tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        addGestureRecognizer(tap)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupView(){
        backgroundColor = sound.color
        alpha = 0.2
        layer.cornerRadius = 10
        clipsToBounds = true
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        print("tapped")
        animatePressed()
        playSound()
    }

    fileprivate func animatePressed(){

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 2
            })
        }
    }

    fileprivate func playSound(){
        print(sound.rawValue, sound.fileExtension)
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: sound.fileExtension) else { return }
        print("found url")
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            players.append(player)
            player.prepareToPlay()
            print(player.play())
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension MidiButton : AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let index = players.firstIndex(of: player)!
        players.remove(at: index)
    }
}
