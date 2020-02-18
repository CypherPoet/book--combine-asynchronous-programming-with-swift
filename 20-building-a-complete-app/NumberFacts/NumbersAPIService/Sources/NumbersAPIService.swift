//
//  File.swift
//  
//
//  Created by Brian Sipple on 2/18/20.
//

import Foundation
import Combine
import Common
import CypherPoetNetStack


public final class NumbersAPIService {
    public var session: URLSession
    public var apiQueue: DispatchQueue
    
    init(
        session: URLSession = .shared,
        queue: DispatchQueue = DispatchQueue(label: "NumbersAPIService", qos: .userInitiated)
    ) {
        self.session = session
        self.apiQueue = queue
    }
}


extension NumbersAPIService: NumbersAPIServicing {}
