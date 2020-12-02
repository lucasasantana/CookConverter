//
//  ProportionalNumbersFormatterTests.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import XCTest

class ProportionalNumbersFormatterTests: XCTestCase {

    var sut: ProportionalNumbersFormatter!
    
    override func setUpWithError() throws {
        sut = ProportionalNumbersFormatter()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testZero() {
        XCTAssertEqual(sut.localizedZero, "0")
    }
    
    func testValueFromFullString() {
        XCTAssertEqual(sut.value(fromLocalizedString: "25 & 3/4"), 25.75)
    }
    
    func testValueFromDecimalString() {
        XCTAssertEqual(sut.value(fromLocalizedString: "3/4"), 0.75)
    }
    
    func testValueFromIntegerString() {
        XCTAssertEqual(sut.value(fromLocalizedString: "35"), 35)
    }
    
    func testValueFromIntegerIndexes() {
        XCTAssertEqual(sut.value(indexes: (4, 0)), 4)
    }
    
    func testValueFromDecimalIndexes() {
        XCTAssertEqual(sut.value(indexes: (0, 3)), 0.5)
    }
    
    func testValueFromFullIndexes() {
        XCTAssertEqual(sut.value(indexes: (27, 5)), 27.75)
    }
    
    func testValueFromInvalidIntegerIndexes() {
        XCTAssertNil(sut.value(indexes: (67, 5)))
    }
    
    func testValueFromInvalidDecimalIndexes() {
        XCTAssertNil(sut.value(indexes: (1, 25)))
    }
    
    func testFullStringFromValue() {
        XCTAssertEqual(sut.localizedString(from: 15.46), "15 & 1/2")
    }
    
    func testFullStringFromValueNextToInt() {
        XCTAssertEqual(sut.localizedString(from: 26.85), "27")
    }
    
    func testDecimalStringFromValue() {
        XCTAssertEqual(sut.localizedString(from: 0.56), "2/3")
    }
    
    func testIntegerStringFromValue() {
        XCTAssertEqual(sut.localizedString(from: 29), "29")
    }
    
    func testStringFromIntegerIndexes() {
        XCTAssertEqual(sut.localizedString(indexes: (4, 0)), "4")
    }
    
    func testStringFromDecimalIndexes() {
        XCTAssertEqual(sut.localizedString(indexes: (0, 3)), "1/2")
    }
    
    func testStringFromFullIndexes() {
        XCTAssertEqual(sut.localizedString(indexes: (27, 5)), "27 & 3/4")
    }
    
    func testStringFromInvalidIntegerIndexes() {
        XCTAssertNil(sut.localizedString(indexes: (67, 5)))
    }
    
    func testStringFromInvalidDecimalIndexes() {
        XCTAssertNil(sut.localizedString(indexes: (1, 25)))
    }
    
    func testIndexesFromInteger() {
        
        let indexes = sut.indexes(from: 27)
        
        XCTAssertEqual(indexes.integer, 27)
        XCTAssertEqual(indexes.decimal, 0)
    }
    
    func testIndexesFromDecimal() {
        
        let indexes = sut.indexes(from: 0.65)
        
        XCTAssertEqual(indexes.integer, 0)
        XCTAssertEqual(indexes.decimal, 4)
    }
    
    func testIndexesFromFullNumber() {
        
        let indexes = sut.indexes(from: 5.10)
        
        XCTAssertEqual(indexes.integer, 5)
        XCTAssertEqual(indexes.decimal, 1)
    }
}
