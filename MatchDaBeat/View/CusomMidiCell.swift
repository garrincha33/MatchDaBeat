//
//  CusomMidiCell.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//


import UIKit
import AVFoundation

public class MidiCell : UICollectionViewCell, UIGestureRecognizerDelegate {
    public var sound : Sounds? {
        didSet{
            url = Bundle.main.url(forResource: sound!.rawValue, withExtension: sound!.fileExtension)
        }
    }
    private var url : URL?
    private var players = [AVAudioPlayer]()
    
    private lazy var buttonArea : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        view.backgroundColor = .lightGray
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    //MARK:- step 4 add light uiview
    private var light = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("midi cell init called")
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        backgroundColor = .clear
        
        
        //tap area
        addSubview(buttonArea)
        buttonArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        buttonArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        buttonArea.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        buttonArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        buttonArea.addGestureRecognizer(tap)
        
        
        //MARK:- step 5 add light
        //light
        //        buttonArea.addSubview(light)
        //        light.backgroundColor = sound?.color
        //        let lightSide = CGFloat(100)
        //        light.translatesAutoresizingMaskIntoConstraints = false
        //        light.centerYAnchor.constraint(equalTo: buttonArea.centerYAnchor).isActive = true
        //        light.centerXAnchor.constraint(equalTo: buttonArea.centerXAnchor).isActive = true
        //        light.heightAnchor.constraint(equalToConstant: lightSide).isActive = true
        //        light.widthAnchor.constraint(equalToConstant: lightSide).isActive = true
        //        light.isHidden = false
    }

    @objc func tapped(_ sender: UITapGestureRecognizer){
        animate()
        playSound()
    }
    
    public func animate(){
        UIView.animate(withDuration: 0.1, animations: {
            //MARK:- step 5 add transforms
            //self.light.isHidden = false
            self.buttonArea.backgroundColor = self.sound?.color
            // self.buttonArea.alpha = 0.2
            //            light.backgroundColor = self.sound?.color
            //            light.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.buttonArea.backgroundColor = .lightGray
                //MARK:- step 6 add transforms
                //   self.light.isHidden = true
                //   self.buttonArea.alpha = 1
                //                light.backgroundColor = .clear
                //                light.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
         //light.removeFromSuperview()
    }
    
    public func playSound(){
        if (sound == Sounds.voice) {
            let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Welcome To Match Da Beat")
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(speechUtterance)
            return
        }
        guard let url = url else {return}
        print("url exists")
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            players.append(player)
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension MidiCell : AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let index = players.firstIndex(of: player)!
        players.remove(at: index)
    }
}
