//
//  MyViewController.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit


class MyViewController : UIViewController {

    override func loadView() {

        let view = MidiView(frame: CGRect(x: 0, y:0, width: 768, height: 512))
        self.view = view

    }
}
