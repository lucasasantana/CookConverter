//
//  MeasureListItemViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Combine
import Foundation

protocol MeasurementItemBusinessLogic {
    
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> { get }
    
    func convert(measure: Double, withUnit unit: UnitVolume)
    func convert(measure: Double, withUnit unit: UnitMass)
}

class MeasureListItemViewModel: MeasureListItemViewModelProtocol {
   
    @Published var isEditing: Bool
    
    @Published var imageName: String
    
    @Published var title: String
    
    @Published var number: String
    
    var indexes: [Int] {
        didSet {
            indexesSubject.send(indexes)
        }
    }
    
    var indexesSubject: CurrentValueSubject<[Int], Never>
    
    var subscribers: Set<AnyCancellable>
    
    var proportionalInputViewModel: ProportionalMeasuresPickerViewModelProtocol?
    
    var measureFormatter: AppMeasureFormatter
    
    var businessLogic: MeasurementItemBusinessLogic
    
    var dimension: AppDimension {
        didSet {
            self.imageName = dimension.iconName
        }
    }
    
    init(
        
        measureFormatter: AppMeasureFormatter,
        businessLogic: MeasurementItemBusinessLogic,
        dimension: AppDimension,
        isEditing: Bool = false
        
    ) {
    
        self.dimension = dimension
        self.measureFormatter = measureFormatter
        
        self.isEditing = isEditing
        self.businessLogic = businessLogic
        
        self.subscribers = Set<AnyCancellable>()
        
        switch dimension.unit {
            
            case .mass(let unit):
                self.title = measureFormatter.localizedString(from: unit).capitalized
                
            case .volume(let unit):
                self.title = measureFormatter.localizedString(from: unit).capitalized
        }
        
        self.number = ""
        self.imageName = dimension.iconName
        
        self.indexes = []
        
        self.indexesSubject = CurrentValueSubject([])
        
        self.cofigureInput()
        self.configureSubscriber()
    }
    
    deinit {
        subscribers.forEach {$0.cancel()}
    }
    
    func cofigureInput() {
        
        if dimension.valueType == .proportional {
            self.indexes = columns.map { _ in return 0 }
            self.proportionalInputViewModel = self
        }
        
        self.setNumber(.zero)
    }
    
    func configureSubscriber() {
        
        businessLogic.defaultMeasuresPublisher
            
            .sink { [weak self] (measures) in
                
                guard let self = self else { return }
                
                let value: Double
                
                switch self.dimension.unit {
                    
                    case .mass(let unit):
                        value = measures.mass.converted(to: unit).value
                        
                    case .volume(let unit):
                        value = measures.volume.converted(to: unit).value
                }
                
                self.setNumber(value)
            }
            .store(in: &subscribers)
    }
    
    func setNumber(_ value: String) {
        
        let value = value.doubleInputFormatting()
        
        guard let doubleValue = measureFormatter.value(fromLocalizedString: value) else {
            self.number = measureFormatter.localizedZero
            return
        }
        
        switch self.dimension.unit {
            
            case .mass(let unit):
                businessLogic.convert(measure: doubleValue, withUnit: unit)
                
            case .volume(let unit):
                businessLogic.convert(measure: doubleValue, withUnit: unit)
        }
    }
    
    private func setNumber(_ value: Double) {
        
        if self.dimension.valueType == .proportional {
            
            let components = value.fractionStringComponents
            
            if let integerPart = components.integer, let index = columns[0].firstIndex(of: integerPart) {
                indexes[0] = index
            } else {
                indexes[0] = .zero
            }
            
            if let decimalPart = components.decimal, let index = columns[1].firstIndex(of: decimalPart) {
                indexes[1] = index
                
            } else {
                indexes[1] = .zero
            }
            
            let integer = columns[0][indexes[0]]
            let decimal = columns[1][indexes[1]]
            
            if integer != "0" && decimal != "0" {
                self.number = "\(integer) \(decimal)"
                
            } else if integer != "0" {
                self.number = integer
                
            } else {
                self.number = decimal
            }
            
        } else {
            self.number = measureFormatter.localizedString(from: value) ?? measureFormatter.localizedZero
        }
    }
}

extension MeasureListItemViewModel: ProportionalMeasuresPickerViewModelProtocol {
    
    var columns: [[String]] {
        [(0...50).map {String($0)}, ["0", "1/4", "1/3", "1/2", "2/3", "3/4"]]
    }
    
    func indexesPublisher() -> AnyPublisher<[Int], Never> {
        return indexesSubject.eraseToAnyPublisher()
    }
    
    func set(index: Int, atColumn column: Int) {
        
        let columns = self.columns
        
        guard
            
            indexes.count == 2,
            column < indexes.count
        
        else {
            return
        }
        
        self.indexes[column] = index
        
        let newValueString = "\(columns[0][indexes[0]]) \(columns[1][indexes[1]])"
        
        switch self.dimension.unit {
            
            case .mass(let unit):
                businessLogic.convert(measure: newValueString.fractionValue, withUnit: unit)
                
            case .volume(let unit):
                businessLogic.convert(measure: newValueString.fractionValue, withUnit: unit)
        }
    }
}
