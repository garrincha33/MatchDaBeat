//
//  MidiView.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

//MARK:- step 5 create midiView

import UIKit

public class MidiView : UIView {
    lazy var parentStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var snare =  MidiButton(frame: .init(x: 16, y: 16, width: 16, height: 16), sound: Sounds(rawValue: "kick") ?? Sounds(rawValue: "snare")!)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
