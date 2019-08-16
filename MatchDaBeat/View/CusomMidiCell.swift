//
//  CusomMidiCell.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//


import UIKit
import AVFoundation

//MARK: -step 1 create a protocol to handle pressing a sound
protocol MidiCellDelegate : AnyObject {
    func pressed(_ cell: MidiCell)
}

public class MidiCell : UICollectionViewCell, UIGestureRecognizerDelegate {
    public var sound : Sounds? {
        didSet{
            url = Bundle.main.url(forResource: sound!.rawValue, withExtension: sound!.fileExtension)
        }
    }
    private var url : URL?
    private var players = [AVAudioPlayer]()
    //MARK: -step 2 create a delegate
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
        buttonArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        buttonArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        buttonArea.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        buttonArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.delegate = self
        buttonArea.addGestureRecognizer(tap)
    }

    @objc func tapped(_ sender: UITapGestureRecognizer){
//        animate()
//        playSound()
//
        //MARK: -step 3 instead of animate and play sound we want to use delegate.pressed
        delegate?.pressed(self)
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
