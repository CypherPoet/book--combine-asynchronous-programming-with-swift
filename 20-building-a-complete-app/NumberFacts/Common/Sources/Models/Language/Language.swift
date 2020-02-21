//
//  File.swift
//  
//
//  Created by Brian Sipple on 2/20/20.
//

import Foundation



public enum Language: String {
    case english
    case spanish
}


extension Language: CaseIterable {}

extension Language: Identifiable {
    public var id: String { code }
}



extension Language {
    
    public init?(code: String) {
        guard let language = Self.allCases.first(where: { $0.code == code }) else {
            return nil
        }
        
        self = language
    }
    
    
    public var shortName: String {
        switch self {
        case .english:
            return "Eng."
        case .spanish:
            return "Esp."
        }
    }
    
    
    public var longName: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        }
    }

    
    public var code: String {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        }
    }
}
