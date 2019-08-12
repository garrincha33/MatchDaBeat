//
//  Enums.swift
//  MatchDaBeat
//
//  Created by Richard Price on 12/08/2019.
//  Copyright © 2019 twisted echo. All rights reserved.
//

 //MARK:- step 3 create enums

import Foundation

extension CaseIterable where AllCases.Element: Equatable {
    static func make(index: Int) -> Self {
        let a = Self.allCases
        return a[a.index(a.startIndex, offsetBy: index)]
    }
    
    func index() -> Int {
        let a = Self.allCases
        return a.distance(from: a.startIndex, to: a.firstIndex(of: self)!)
    }
}

public enum Sounds : String {
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
}
