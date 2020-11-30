//
//  StringTests.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import XCTest

class StringTests: XCTestCase {

    func testOneElementFraction() {
        
        let sut = "1/2"
        
        XCTAssertEqual(sut.fractionValue, 0.5)
    }
    
    func testTwoElements() {
        
        let sut = "1 1/2"
        
        XCTAssertEqual(sut.fractionValue, 1.5)
    }
    
    func testDivisionByZero() {
        
        let sut = "1/0"
        
        XCTAssertEqual(sut.fractionValue, .zero)
    }
    
    func testZeroSum() {
        
        let sut = "0 1/2"
        
        XCTAssertEqual(sut.fractionValue, 0.5)
    }
    
    func testInvalidString() {
        
        let sut = "asasasasa"
        
        XCTAssertEqual(sut.fractionValue, 0.0)
    }
    
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
