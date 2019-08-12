//
//  MidiView.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit

public class MidiView : UIView {
   
    //MARK: - step 7 add lazy sounds
    lazy var snare = MidiButton(sound: Sounds.snare)
    lazy var crash = MidiButton(sound: Sounds.crash)
    lazy var kick = MidiButton(sound: Sounds.kick)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK: - step 9 call setup midi
        setupMidi()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - step 8 & step 11 add subview to display
    fileprivate func setupMidi(){
        backgroundColor = .white
        isMultipleTouchEnabled = true
        isUserInteractionEnabled = true
        let stack = UIStackView(frame: frame)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let topStack = UIStackView()
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        topStack.addArrangedSubview(crash)
        topStack.addArrangedSubview(snare)
        
        let bottomStack = UIStackView()
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.addArrangedSubview(kick)
        
        stack.addArrangedSubview(topStack)
        stack.addArrangedSubview(bottomStack)
    }
}
