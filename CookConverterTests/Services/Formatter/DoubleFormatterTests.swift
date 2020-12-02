//
//  DoubleFormatter.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import XCTest

class DoubleFormatterTests: XCTestCase {
    
    var sut: DoubleFormatter!

    override func setUpWithError() throws {
        sut = DoubleFormatter(locale: Locale(identifier: "en-US"))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testZero() {
        XCTAssertEqual(sut.localizedZero, "0.00")
    
    }

    func testValueFromString() {
        XCTAssertEqual(sut.value(fromLocalizedString: "25.31"), 25.31)
    }
    
    func testStringFromValue() {
        XCTAssertEqual(sut.localizedString(from: 25.04), "25.04")
    }
    
    func testLocale() {
        
        let number: Double = 4.50
        
        sut = DoubleFormatter(locale: Locale(identifier: "pt-BR"))
        
        let components = sut.localizedString(from: number)?.components(separatedBy: ",")
        
        XCTAssertEqual("4", components?[0])
        XCTAssertEqual("50", components?[1])
    }
}
