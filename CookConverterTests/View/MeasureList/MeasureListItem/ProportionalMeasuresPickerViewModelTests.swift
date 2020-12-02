//
//  ProportionalMeasuresPickerViewModelTests.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import XCTest
import Combine

class ProportionalMeasuresPickerViewModelTests: XCTestCase {
    
    var sut: ProportionalMeasuresPickerViewModel!
    var set: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        sut = ProportionalMeasuresPickerViewModel()
        set = Set()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        set = nil
    }
    
    func testSetNumber() {
        
        let expec = XCTestExpectation()
        var firstCall: Bool = true
        
        sut.indexesPublisher()
            .sink { (values) in
                
                if firstCall {
                    
                    XCTAssertEqual(values[0], .zero)
                    XCTAssertEqual(values[1], .zero)
                    
                    firstCall = false
                    
                } else {
                    
                    XCTAssertEqual(values[0], 28)
                    XCTAssertEqual(values[1], 3)
                    
                    expec.fulfill()
                }
                
            }
            .store(in: &set)
        
        let string = sut.set(number: 28.5)
        
        XCTAssertEqual(string, "28 & 1/2")
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testSetInvalidNumber() {
        
        let expec = XCTestExpectation()
        var firstCall: Bool = true
        
        sut.indexesPublisher()
            .sink { (values) in
                
                if firstCall {
                    
                    XCTAssertEqual(values[0], .zero)
                    XCTAssertEqual(values[1], .zero)
                    
                    firstCall = false
                    
                } else {
                    
                    XCTAssertEqual(values[0], .zero)
                    XCTAssertEqual(values[1], .zero)
                    
                    expec.fulfill()
                }
                
            }
            .store(in: &set)
        
        let string = sut.set(number: 1000)
        
        XCTAssertEqual(string, "1000")
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testCurrentFullNumber() {
        
        _ = sut.set(number: 35.34)
        
        XCTAssertEqual(35.5, sut.currentNumber)
        XCTAssertEqual("35 & 1/2", sut.currentNumberString)
    }
    
    func testCurrentIntegerNumber() {
        
        _ = sut.set(number: 35)
        
        XCTAssertEqual(35, sut.currentNumber)
        XCTAssertEqual("35", sut.currentNumberString)
    }
    
    func testCurrentDecimalNumber() {
        
        _ = sut.set(number: 0.35)
        
        XCTAssertEqual(0.5, sut.currentNumber)
        XCTAssertEqual("1/2", sut.currentNumberString)
    }
    
    func testColumn() {
        
        let expec = XCTestExpectation()
        var firstCall: Bool = true
        
        sut.indexesPublisher()
            .sink { (values) in
                
                if firstCall {
                    
                    XCTAssertEqual(values[0], .zero)
                    XCTAssertEqual(values[1], .zero)
                    
                    firstCall = false
                    
                } else {
                    
                    XCTAssertEqual(values[0], 0)
                    XCTAssertEqual(values[1], 5)
                    
                    expec.fulfill()
                }
                
            }
            .store(in: &set)
        
        sut.set(index: 5, atColumn: 1)
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testCurrentFullNumberColumns() {
        
        sut.set(index: 35, atColumn: 0)
        sut.set(index: 3, atColumn: 1)
        
        XCTAssertEqual(35.5, sut.currentNumber)
        XCTAssertEqual("35 & 1/2", sut.currentNumberString)
    }
    
    func testCurrentIntegerNumberColumn() {
        
        sut.set(index: 35, atColumn: 0)
        
        XCTAssertEqual(35, sut.currentNumber)
        XCTAssertEqual("35", sut.currentNumberString)
    }
    
    func testCurrentDecimalNumberColumn() {
        
        sut.set(index: 3, atColumn: 1)
        
        XCTAssertEqual(0.5, sut.currentNumber)
        XCTAssertEqual("1/2", sut.currentNumberString)
    }
}
