//
//  Enums.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//


import UIKit

extension CaseIterable where AllCases.Element: Equatable {
    static func make(index: Int) -> Self {
        let a = Self.allCases
        return a[a.index(a.startIndex, offsetBy: index)]
    }
}

public enum Sounds : String, CaseIterable {
    case crash
    case kick
    case snare
    case voice

    public enum ext : String {
        case mp3
        case wav
    }
    
    var fileExtension: String {
        switch self {
        case .crash:
            return ext.mp3.rawValue
        case .snare:
            return ext.mp3.rawValue
        case .kick:
            return ext.mp3.rawValue
        case .voice:
            return ext.wav.rawValue
        }
    }

    var color: UIColor {
        switch self {
        case .crash:
            return UIColor.blue
        case .snare:
            return UIColor.purple
        case .kick:
            return UIColor.green
            //MARK:- step 4 add color
        case .voice:
            return UIColor.red
        }
    }
}


