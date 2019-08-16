//
//  GameViewController.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

import UIKit
import AVFoundation

public class GameViewController : UIViewController {
    private var engine = AVAudioEngine()
    
    //MARK:- step 1 make private lables
    private lazy var levelLabel : UILabel = {
        let label = UILabel()
        label.text = "Level:"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        //label.textAlignment = .left
        return label
    }()
    
    private lazy var resetButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named: "resetbutton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK:- step 2 make private Visulaizer and MidiView objects
    private var visualizer : Visualizer!
    private var midiView : MidiView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        setupEngine()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        setupViews()
    }
    
    private func setupViews(){
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
        
        
        midiView = MidiView(engine: engine)
        view.addSubview(midiView!)
        //MARK:- step 3 remove optional binding and constant
        midiView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        midiView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        midiView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let midiHeight = view.bounds.height*0.30
        midiView?.heightAnchor.constraint(equalToConstant: midiHeight).isActive = true
        //MARK:- step 4 add visulaizert
        visualizer = Visualizer(engine: engine)
        view.addSubview(visualizer)
        visualizer.topAnchor.constraint(equalTo: topStack.bottomAnchor).isActive = true
        visualizer.bottomAnchor.constraint(equalTo: midiView.topAnchor).isActive = true
        visualizer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualizer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    fileprivate func setupEngine(){
        //setup engine
        //MARK:- step 5 remove mainMixerNode
        engine.mainMixerNode //initialzing the output node to be able to start the engine
        engine.prepare()
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
    
    @objc func restart(_ sender: UIButton){
        
    }
}
