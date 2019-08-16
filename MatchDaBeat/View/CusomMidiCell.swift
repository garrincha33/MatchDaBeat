//
//  CusomMidiCell.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//


import UIKit
import AVFoundation

protocol MidiCellDelegate : AnyObject {
    func pressed(_ cell: MidiCell)
}

public class MidiCell : UICollectionViewCell, UIGestureRecognizerDelegate {

    //MARK:- step 1 add light to sound color with didset
    public var sound : Sounds?{
        didSet{
            light.backgroundColor = sound?.color
        }
    }
    public var engine : AVAudioEngine?{
        didSet{
            setupNode()
        }
    }

    private var player = AVAudioPlayerNode()
    private var audioFile = AVAudioFile()
    weak var delegate : MidiCellDelegate?
    
    private lazy var buttonArea : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        //MARK:- step 2 make clear and add a border round the button
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    //MARK:- step 3 make cover over button
    private lazy var buttonCover : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        //blur and vibrancy
        //        let blur = UIBlurEffect(style: .extraLight)
        //        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        //        let blurView = UIVisualEffectView(effect: blur)
        //        blurView.translatesAutoresizingMaskIntoConstraints = false
        //        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        //        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(blurView)
        //        view.addSubview(vibrancyView)
        //
        //        vibrancyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        vibrancyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        vibrancyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        vibrancyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //
        //        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }()
    
    //MARK:- step 4 add light property
    private lazy var light : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()

    
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
        //button area
        addSubview(buttonArea)
        buttonArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        buttonArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        buttonArea.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        buttonArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        buttonArea.addGestureRecognizer(tap)
        
        //MARK:- step 5 add button area to subview and button cover
        //light
        buttonArea.addSubview(light)
        light.centerXAnchor.constraint(equalTo: buttonArea.centerXAnchor).isActive = true
        light.centerYAnchor.constraint(equalTo: buttonArea.centerYAnchor).isActive = true
        light.widthAnchor.constraint(equalToConstant: 50).isActive = true
        light.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //light.isHidden = true
        
        buttonArea.addSubview(buttonCover)
        buttonCover.leadingAnchor.constraint(equalTo: buttonArea.leadingAnchor).isActive = true
        buttonCover.trailingAnchor.constraint(equalTo: buttonArea.trailingAnchor).isActive = true
        buttonCover.topAnchor.constraint(equalTo: buttonArea.topAnchor).isActive = true
        buttonCover.bottomAnchor.constraint(equalTo: buttonArea.bottomAnchor).isActive = true
        
    }

    fileprivate func setupNode(){
        let url = Bundle.main.url(forResource: sound!.rawValue, withExtension: sound!.fileExtension)!
        do {
            audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            engine!.attach(player)
            engine!.connect(player, to: engine!.mainMixerNode, format: format)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @objc func tapped(_ sender: UITapGestureRecognizer){
        delegate?.pressed(self)
    }

    public func play(){
        player.scheduleFile(audioFile, at: nil, completionHandler: nil)
        player.play()
    }
    
    public func animate(){
        UIView.animate(withDuration: 0.1, animations: {
            //MARK:- step 6 adjust animation so when tapped buttons color animates
            self.light.transform = CGAffineTransform(scaleX: 3, y: 3)
        }) { (_) in
            //MARK:- step 6 adjust animation so when tapped buttons color animates
            UIView.animate(withDuration: 0.1, animations: {
                self.light.transform = CGAffineTransform.identity
            })
        }
    }
}
