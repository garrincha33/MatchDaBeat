//
//  GameViewController.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit

//MARK:- step 1 import av foundation to use at top level
import AVFoundation

public class GameViewController : UIViewController {
    //MARK:- step 2 import av foundation to use at top level
    private var engine = AVAudioEngine()
    
    lazy var levelLabel : UILabel = {
        let label = UILabel()
        label.text = "Level:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //MARK:- step 3 change lable to white
        label.textColor = .white
        //label.textAlignment = .left
        return label
    }()
    
    lazy var resetButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "resetbutton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        //MARK:- step 3 change lable to white
        button.tintColor = .white
        button.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var midiView : MidiView?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        //MARK:- step 4 use setupEngine function
        setupEngine()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        setupViews()
    }
    
        private func setupViews(){
            //MARK:- step 5 bg color to black
        view.backgroundColor = .black
        
        //topstack
        let topStack = UIStackView()
        topStack.axis = .horizontal
        topStack.distribution = .fillProportionally
        topStack.translatesAutoresizingMaskIntoConstraints = false

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
        //midiView = MidiView()
            //MARK:- step 6 create new instance of midiView with engine imput
        midiView = MidiView(engine: engine)
        view.addSubview(midiView!)
        midiView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        midiView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        midiView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let midiHeight = view.bounds.height*0.30
        midiView?.heightAnchor.constraint(equalToConstant: midiHeight).isActive = true
        
    }
    //MARK:- step 7 create setupEngine func
    fileprivate func setupEngine(){
        //setup engine
        engine.mainMixerNode //initialzing the output node to be able to start the engine
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print(error)
        }
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { (buffer, time) in
            
        }
    }
    
    @objc func restart(_ sender: UIButton){
        
    }
}
