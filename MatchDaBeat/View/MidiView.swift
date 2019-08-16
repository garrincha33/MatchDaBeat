//
//  MidiView.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit
//MARK: -step 4 import avfoudnatuion
import AVFoundation

public class MidiView : UIView {

    private var sounds = [Sounds.snare, Sounds.crash, Sounds.kick] //remove voice here and from enum
    private var identifier = "cell"
    
    //MARK: -step 5 create engine, players and the files we are want to play
    private var engine = AVAudioEngine()
    private var players = [AVAudioPlayerNode]()
    private var files = [AVAudioFile]()

    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MidiCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    
    public required init() {
        super.init(frame: .zero)
        setupMidi()
        //MARK: -step 5 create engine, players and the files we are want to play
        setupEngineAndPlayers()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupMidi(){
        print("setup midi called")
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.cornerRadius = 20
        clipsToBounds = true
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
        collectionView.addGestureRecognizer(longPress)

    }

    @objc func handleMoveGesture(_ sender : UILongPressGestureRecognizer){
        switch(sender.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    //MARK: -step 6 create the engine and players function
    fileprivate func setupEngineAndPlayers(){
        //populate players
        for sound in sounds {
            let url = Bundle.main.url(forResource: sound.rawValue, withExtension: sound.fileExtension)!
            do {
                let audioFile = try AVAudioFile(forReading: url)
                files.append(audioFile)
                let format = audioFile.processingFormat
                let player = AVAudioPlayerNode()
                players.append(player)
                engine.attach(player)
                engine.connect(player, to: engine.mainMixerNode, format: format)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        //setup engine
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
}

extension MidiView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sounds.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MidiCell
        cell.sound = sounds[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //selection
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK:- step 9 remove did select
//        guard let cell = collectionView.cellForItem(at: indexPath) as? MidiCell else {return}
//        cell.animate()
//        cell.playSound()
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //sizing
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 9
        let height = collectionView.bounds.height / 2 - 6
        return CGSize(width: width, height: height)
    }
    
    //moving
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let soundToMove = sounds[sourceIndexPath.item]
        sounds.remove(at: sourceIndexPath.item)
        sounds.insert(soundToMove, at: destinationIndexPath.item)
        //MARK: -step 7 create playerToMove indexes
        let playerToMove = players[sourceIndexPath.item]
        players.remove(at: sourceIndexPath.item)
        players.insert(playerToMove, at: destinationIndexPath.item)
    }
    //spacing
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 5, bottom: 0, right: 0)
    }

}

//MARK: -step 8 use midiCellDelegate and create actions for presssed function
extension MidiView : MidiCellDelegate {
    func pressed(_ cell: MidiCell) {
        cell.animate()
        let index = sounds.firstIndex(of: cell.sound!)!
        let player = players[index]
        player.scheduleFile(files[index], at: nil, completionHandler: nil)
        player.play()
        print(players[index])
    }
}
