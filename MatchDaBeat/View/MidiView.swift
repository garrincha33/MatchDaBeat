//
//  MidiView.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit

public class MidiView : UIView {

//    lazy var snare = MidiButton(sound: Sounds.snare)
//    lazy var crash = MidiButton(sound: Sounds.crash)
//    lazy var kick = MidiButton(sound: Sounds.kick)
    
    //MARK:- step 1 make array of sounds
    private var sounds = [Sounds.snare, Sounds.crash, Sounds.kick]
    private var identifier = "cell"

    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        //MARK:- step 3 enable scorlling
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MidiCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupMidi()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupMidi(){
        print("setup midi called")
        backgroundColor = .gray
        layer.cornerRadius = 20
        clipsToBounds = true
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        //MARK:- step 4 adjust top anchor
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        //MARK:- step 5 add long press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
        collectionView.addGestureRecognizer(longPress)

    }
    //MARK:- step 6 create selector handle move function
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
}
//MARK:- step 7 amend extension
extension MidiView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sounds.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MidiCell
        //MARK:- step 2 sounds = index path
        cell.sound = sounds[indexPath.row]
        return cell
    }
    
    //selection
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MidiCell else {return}
        cell.animate()
        cell.playSound()
    }
    
    //sizing
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.width / 3 - 10
        return CGSize(width: side, height: side)
    }
    
    //moving
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let soundToMove = sounds[sourceIndexPath.item]
        sounds.remove(at: sourceIndexPath.item)
        sounds.insert(soundToMove, at: destinationIndexPath.item)
    }
    //spacing
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 5, bottom: 0, right: 0)
    }

}
