//
//  ProportionalMeasuresPickerViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 02/12/20.
//

import Combine
import Foundation

class ProportionalMeasuresPickerViewModel: InputPickerViewModelProtocol {
    
    private(set) var columns: [[String]]
    
    private var indexes: [Int]
    
    private var formatter: ProportionalNumbersFormatter
    
    private var indexesSubject: CurrentValueSubject<[Int], Never>
    private var numberSubject: CurrentValueSubject<Double, Never>
    
    var currentNumberString: String? {
        
        guard indexes.count == 2 else {
            return nil
        }
        
        return formatter.localizedString(indexes: (indexes[0], indexes[1]))
    }
    
    var currentNumber: Double? {
        
        guard indexes.count == 2 else {
            return nil
        }
        
        return formatter.value(indexes: (indexes[0], indexes[1]))
    }
    
    init(formatter: ProportionalNumbersFormatter = .appFormatter) {
        
        let values = formatter.avaliableNumbers
        let valuesIndexes = values.map { _ in return 0}
        
        self.columns = values
        self.indexes = valuesIndexes
        self.indexesSubject = CurrentValueSubject(valuesIndexes)
        self.numberSubject = CurrentValueSubject(.zero)
        self.formatter = formatter
    }
    
    func indexesPublisher() -> AnyPublisher<[Int], Never> {
        return indexesSubject.eraseToAnyPublisher()
    }
    
    func numberPublisher() -> AnyPublisher<Double, Never> {
        return numberSubject.eraseToAnyPublisher()
    }
    
    func set(index: Int, atColumn column: Int) {
        
        guard
            
            column < indexes.count,
            column < columns.count,
            index < columns[column].count
        
        else {
            return
        }
        
        indexes[column] = index
        indexesSubject.send(self.indexes)
        
        if let number = formatter.value(indexes: (indexes[0], indexes[1])) {
            numberSubject.send(number)
        }
    }
    
    func set(number: Double) -> String {
        
        guard let string = formatter.localizedString(from: number) else {
            
            self.indexes[0] = .zero
            self.indexes[1] = .zero
            
            indexesSubject.send(self.indexes)
            
            return formatter.localizedZero
        }
        
        let indexes = formatter.indexes(from: number)
        
        self.indexes[0] = indexes.integer
        self.indexes[1] = indexes.decimal
        
        indexesSubject.send(self.indexes)
        
        return string
    }
}
