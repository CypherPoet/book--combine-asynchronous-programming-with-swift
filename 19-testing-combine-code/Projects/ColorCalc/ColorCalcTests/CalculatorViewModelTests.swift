//
//  CalculatorViewModelTests.swift
//  ColorCalcTests
//
//  Created by Brian Sipple on 1/8/20.
//  Copyright © 2020 Scott Gardner. All rights reserved.
//

import XCTest
import Combine
import SwiftUI
@testable import ColorCalc


class CalculatorViewModelTests: XCTestCase {
    var viewModel: CalculatorViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CalculatorViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscriptions.removeAll()
    }
}


extension CalculatorViewModelTests {
    
    func test_receivingTheCorrectNameWhenHexTextIsSet() {
        let expected = "rwGreen 66%"
        var actual = ""
        
        viewModel.$name
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "#006636AA"
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_receivingTheCorrectBackgroundColorWhenHexTextIsSet() {
        let expected = Color(hex: ColorName.rwGreen.rawValue)!
        var actual = Color.clear
        
        viewModel.$color
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = ColorName.rwGreen.rawValue
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_processingBackspaceDeletesLastHexCharacter() {
        let expected = "#0080F"
        var actual = ""
        
        viewModel.$hexText
            .dropFirst()
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        
        viewModel.process(CalculatorViewModel.Constant.backspace)
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_receivingCorrectColorAfterProcessingBackspace() {
        let expected = Color.white
        var actual = Color.clear
        
        viewModel.$color
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        viewModel.process(CalculatorViewModel.Constant.backspace)
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_receivingWhiteColorAfterBadDataIsInput() {
        let expected = Color.white
        var actual = Color.clear
        
        viewModel.$color
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "Not a hex value"
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_clearingTheHextTextAfterProcessingClearInput() {
        let expected = "#"
        var actual = "🦄"
        
        
        viewModel.$hexText
            .dropFirst()
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        
        viewModel.process(CalculatorViewModel.Constant.clear)
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_receivingTheCorrectRGBOValueAfterProcessingHexText() {
//        let expected = Color(
//            .displayP3,
//            red: 0,
//            green: 102,
//            blue: 54,
//            opacity: 170
//        )
        let expected = "0, 102, 54, 170"
        var actual = ""
        
        
        viewModel.$rgboText
            .sink(receiveValue: { actual = $0 })
            .store(in: &subscriptions)
        
        viewModel.hexText = "#006636AA"
        
        XCTAssertEqual(actual, expected)
    }
}
