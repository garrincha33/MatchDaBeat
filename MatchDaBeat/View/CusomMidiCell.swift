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

    public var sound : Sounds?
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
        view.backgroundColor = .lightGray
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
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
        addSubview(buttonArea)
        //MARK:- step 8 adjust constants
        buttonArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        buttonArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        buttonArea.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        buttonArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        buttonArea.addGestureRecognizer(tap)
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
            self.buttonArea.backgroundColor = self.sound?.color
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.buttonArea.backgroundColor = .lightGray
            })
        }
    }
}
