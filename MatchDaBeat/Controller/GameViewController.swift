//
//  GameViewController.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit

public class GameViewController : UIViewController {
    
    lazy var levelLabel : UILabel = {
        let label = UILabel()
        label.text = "Level:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .lightGray
        //MARK:- step 1 align left
        //label.textAlignment = .left
        return label
    }()
    
    lazy var resetButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "resetbutton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        //MARK:- step 2 import reset button and add automask
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var midiView : MidiView?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        setupViews()
    }
    
        private func setupViews(){
        view.backgroundColor = .white
        
        //topstack
        let topStack = UIStackView()
        topStack.axis = .horizontal
        topStack.distribution = .fillProportionally
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
            //MARK:- step 3 add constraints for button
        resetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        topStack.addArrangedSubview(levelLabel)
        topStack.addArrangedSubview(resetButton)
        
        view.addSubview(topStack)
        topStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3).isActive = true
        topStack.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        print(view.bounds)
        
        //midiview
        midiView = MidiView()
        view.addSubview(midiView!)
        midiView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        midiView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        midiView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            //MARK:- step 4 adjust midi hieght
        let midiHeight = view.bounds.height*0.30
        midiView?.heightAnchor.constraint(equalToConstant: midiHeight).isActive = true
        
    }
    
    @objc func restart(_ sender: UIButton){
        
    }
}
