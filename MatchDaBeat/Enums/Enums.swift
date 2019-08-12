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
//MARK:- step 1 make sounds CaseIterable
public enum Sounds : String, CaseIterable {
    case crash
    case kick
    case snare

    
    public enum ext : String {
        case mp3
    }
    
    var fileExtension: String {
        switch self {
        case .crash:
            return ext.mp3.rawValue
        case .snare:
            return ext.mp3.rawValue
        case .kick:
            return ext.mp3.rawValue
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
        }
    }
}


