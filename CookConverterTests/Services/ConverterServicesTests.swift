//
//  ConverterServicesTests.swift
//  CookConverterTests
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import XCTest
import Combine
import Foundation

class ConverterServicesTests: XCTestCase {
    
    var subscribers: Set<AnyCancellable>!
    
    var mockProduct: Product!
    
    var sut: ConverterServices!

    override func setUpWithError() throws {
        subscribers = Set()
        mockProduct = Product(name: "aaa", density: 1.0)
        sut = ConverterServices(product: mockProduct)
    }

    override func tearDownWithError() throws {
        subscribers = nil
        mockProduct = nil
        sut = nil
    }
    
    func testVolumeToVolumeConversion() {
        
        let expec = XCTestExpectation()
        let mockMeasurement = Measurement(value: 1.0, unit: UnitVolume.cubicMeters)
        
        sut.defaultMeasuresPublisher
            .sink { (measures) in
                
                guard measures.volume.value != .zero else {return}
                
                let converted = measures.volume.converted(to: mockMeasurement.unit)
                
                XCTAssertEqual(converted.value, mockMeasurement.value)
                
                expec.fulfill()
            }
            .store(in: &subscribers)
        
        sut.convert(measure: mockMeasurement.value, withUnit: mockMeasurement.unit)
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testMassToMassConversion() {
        
        let expec = XCTestExpectation()
        let mockMeasurement = Measurement(value: 1.0, unit: UnitMass.kilograms)
        
        sut.defaultMeasuresPublisher
            .sink { (measures) in
                
                guard measures.mass.value != .zero else {return}
                
                let converted = measures.mass.converted(to: mockMeasurement.unit)
                
                XCTAssertEqual(converted.value, mockMeasurement.value)
                
                expec.fulfill()
            }
            .store(in: &subscribers)
        
        sut.convert(measure: mockMeasurement.value, withUnit: mockMeasurement.unit)
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testVolumeToMassConversion() {
        
        let expec = XCTestExpectation()
        let mockMeasurement = Measurement(value: 1.0, unit: UnitVolume.cubicCentimeters)
        
        sut.defaultMeasuresPublisher
            .sink { [weak self] (measures) in
                
                guard let self = self, measures.volume.value != .zero else {
                    return
                }
                
                let convertedVolume = measures.volume.converted(to: mockMeasurement.unit)
                
                let defaultVolume = measures.volume
                let defaultMass = measures.mass
                
                XCTAssertEqual(convertedVolume.value, mockMeasurement.value)
                
                XCTAssertEqual(defaultVolume.value, defaultMass.value * self.mockProduct.density)

                expec.fulfill()
            }
            .store(in: &subscribers)
        
        sut.convert(measure: mockMeasurement.value, withUnit: mockMeasurement.unit)
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testMassToVolumeConversion() {
        
        let expec = XCTestExpectation()
        let mockMeasurement = Measurement(value: 1.0, unit: UnitMass.grams)
        
        sut.defaultMeasuresPublisher
            .sink { [weak self] (measures) in
                
                guard let self = self, measures.mass.value != .zero else {
                    return
                }
                
                let convertedMass = measures.mass.converted(to: mockMeasurement.unit)
                
                let defaultVolume = measures.volume
                let defaultMass = measures.mass
                
                XCTAssertEqual(convertedMass.value, mockMeasurement.value)
                
                XCTAssertEqual(defaultVolume.value, defaultMass.value / self.mockProduct.density)
                
                expec.fulfill()
            }
            .store(in: &subscribers)
        
        sut.convert(measure: mockMeasurement.value, withUnit: mockMeasurement.unit)
        
        wait(for: [expec], timeout: 1.0)
    }
    
    func testUpdate() {
        
        let density: Double = 78464684984
        
        sut.update(product: Product(name: "", density: density))
        
        XCTAssertEqual(sut.density, density)
    }
    
    func testMassToVolumeConversionWithZeroDensity() {
        
        let expec = XCTestExpectation()
        let mockMeasurement = Measurement(value: 1.0, unit: UnitMass.grams)
        
        sut.update(product: Product(name: "", density: .zero))
        
        sut.defaultMeasuresPublisher
            .sink { (measures) in
                
                guard measures.mass.value != .zero else {
                    return
                }
                
                let convertedMass = measures.mass.converted(to: mockMeasurement.unit)
                
                let defaultVolume = measures.volume
                
                XCTAssertEqual(convertedMass.value, mockMeasurement.value)
                
                XCTAssertEqual(defaultVolume.value, .zero)
                
                expec.fulfill()
            }
            .store(in: &subscribers)
        
        sut.convert(measure: mockMeasurement.value, withUnit: mockMeasurement.unit)
        
        wait(for: [expec], timeout: 1.0)
    }
}
