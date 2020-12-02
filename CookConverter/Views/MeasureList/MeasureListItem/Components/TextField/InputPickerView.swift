//
//  InputPickerView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 30/11/20.
//

import SwiftUI
import Combine

protocol InputPickerViewModelProtocol {
    
    var columns: [[String]] { get }
    
    var currentNumberString: String? { get }
    
    var currentNumber: Double? { get }
    
    func indexesPublisher() -> AnyPublisher<[Int], Never>
    
    func numberPublisher() -> AnyPublisher<Double, Never>
    
    func set(index: Int, atColumn column: Int)
    
    func set(number: Double) -> String
}

class InputPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var viewModel: InputPickerViewModelProtocol
    
    private var subscribers: Set<AnyCancellable>
    
    init(viewModel: InputPickerViewModelProtocol) {
        
        self.viewModel = viewModel
        self.subscribers = Set()
        
        super.init(frame: .zero)
        
        delegate = self
        dataSource = self
        
        configureSubscriber()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubscriber() {
        
        viewModel.indexesPublisher()
            .sink { [weak self] (indexes) in
                
                for i in 0..<indexes.count {
                    self?.selectRow(indexes[i], inComponent: i, animated: false)
                }
            }
            .store(in: &subscribers)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.columns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard component < viewModel.columns.count else {
            return .zero
        }
        
        return viewModel.columns[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard component < viewModel.columns.count, row < viewModel.columns[component].count else {
            return nil
        }
        
        return viewModel.columns[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return viewModel.set(index: row, atColumn: component)
    }
}
