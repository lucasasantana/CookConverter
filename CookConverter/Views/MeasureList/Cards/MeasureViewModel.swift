//
//  MeasureListItemViewModel.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 29/11/20.
//

import Combine
import Foundation

protocol MeasurementBusinessLogic {
    
    var defaultMeasuresPublisher: AnyPublisher<DefaultMeasures, Never> { get }
    
    func convert(measure: Double, withUnit unit: UnitVolume)
    func convert(measure: Double, withUnit unit: UnitMass)
}

class MeasureViewModel: MeasureViewModelProtocol {
    
    @Published var isEditing: Bool
    
    @Published var imageName: String
    
    @Published var title: String
    
    @Published var number: String
    
    var subscribers: Set<AnyCancellable>
    
    var proportionalInputViewModel: (InputPickerViewModelProtocol)?
    
    var measureFormatter: AppMeasureFormatter
    
    var businessLogic: MeasurementBusinessLogic
    
    var dimension: AppDimension {
        didSet {
            self.imageName = dimension.iconName
        }
    }
    
    init(
        
        measureFormatter: AppMeasureFormatter,
        businessLogic: MeasurementBusinessLogic,
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
        
        self.cofigureInput()
        self.configureSubscriber()
    }
    
    deinit {
        subscribers.forEach {$0.cancel()}
    }
    
    func cofigureInput() {
        
        if dimension.valueType == .proportional {
            self.proportionalInputViewModel = ProportionalMeasuresPickerViewModel()
        }
        
        self.updateNumber(.zero)
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
                
                self.updateNumber(value)
            }
            .store(in: &subscribers)
        
        if let proportionalInputViewModel = proportionalInputViewModel {
            
            proportionalInputViewModel.numberPublisher()
                
                .sink { [weak self] (value) in
                    
                    guard let self = self else { return }
                    
                    self.setNumber(value)
                }
                .store(in: &subscribers)
        }
    }
    func setNumber(_ value: String) {
        
        let formattedValue: String
        
        if value.count < 8 {
            formattedValue = value.doubleInputFormatting()
            
        } else {
            formattedValue = value
        }
    
        guard let doubleValue = measureFormatter.value(fromLocalizedString: formattedValue) else {
            self.number = measureFormatter.localizedZero
            return
        }
        
        self.setNumber(doubleValue)
    }
    
    func setNumber(_ value: Double) {
        
        switch self.dimension.unit {
            
            case .mass(let unit):
                businessLogic.convert(measure: value, withUnit: unit)
                
            case .volume(let unit):
                businessLogic.convert(measure: value, withUnit: unit)
        }
    }
    
    private func updateNumber(_ value: Double) {
        
        var string: String?
        
        if self.dimension.valueType == .proportional {
            string = proportionalInputViewModel?.set(number: value)
            
        } else {
            string = measureFormatter.localizedString(from: value)
        }
        
        self.number = string ?? measureFormatter.localizedZero
    }
}
