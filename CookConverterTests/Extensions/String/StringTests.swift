//
//  StringTests.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import XCTest

class StringTests: XCTestCase {
    
    func testDoubleInput() {
        
        let sut = "0.010"
        
        let formatter = DoubleFormatter(locale: Locale(identifier: "en-US"))
        
        XCTAssertEqual(sut.doubleInputFormatting(formatter: formatter), "0.10")
    }
    
    func testToDouble() {
        
        let sut = "0.01"
        
        let formatter = DoubleFormatter(locale: Locale(identifier: "en-US"))
        
        XCTAssertEqual(sut.toDouble(formatter: formatter), 0.01)
    }
}
