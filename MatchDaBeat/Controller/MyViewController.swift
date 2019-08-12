//
//  MyViewController.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit


class MyViewController : UIViewController {
    
    //MARK:- step 1
    
    override func loadView() {
        
        //MARK:- step 6 create test button
        let button = MidiButton(frame: .zero, sound: Sounds.kick)
        self.view = button
    }
    
}
