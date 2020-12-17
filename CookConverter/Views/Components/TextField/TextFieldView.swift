//
//  TextFieldView.swift
//  CookConverter
//
//  Created by Lucas Antevere Santana on 27/11/20.
//

import SwiftUI

struct TextFieldView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var didBeginEditing: () -> Void = { }
    var didChange: () -> Void = { }
    var didEndEditing: () -> Void = { }
    
    private var toolbar: Bool
    
    private var font: UIFont?
    private var foregroundColor: UIColor?
    private var accentColor: UIColor?
    private var textAlignment: NSTextAlignment?
    private var contentType: UITextContentType?
    private var title: String?
    private var inputView: UIView?
    
    private var autocorrection: UITextAutocorrectionType = .default
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var keyboardType: UIKeyboardType = .default
    private var returnKeyType: UIReturnKeyType = .default
    
    private var isSecure: Bool = false
    private var isUserInteractionEnabled: Bool = true
    private var clearsOnBeginEditing: Bool = false
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    init(_ title: String,
         text: Binding<String>,
         isEditing: Binding<Bool>,
         withToolbar: Bool = false,
         didBeginEditing: @escaping () -> Void = { },
         didChange: @escaping () -> Void = { },
         didEndEditing: @escaping () -> Void = { }
    ) {
        self.title = title
        self._text = text
        self._isEditing = isEditing
        self.didBeginEditing = didBeginEditing
        self.didChange = didChange
        self.didEndEditing = didEndEditing
        self.toolbar = withToolbar
    }
    
    func makeUIView(context: Context) -> UITextField {
        
        let textField = PaddingTextField(inset: 8, axis: [.vertical])
        
        context.coordinator.textField = textField
        
        textField.delegate = context.coordinator
        
        textField.text = text
        textField.font = font
        textField.textColor = foregroundColor
        
        textField.placeholder = title
        
        if let textAlignment = textAlignment {
            textField.textAlignment = textAlignment
        }
        
        if let contentType = contentType {
            textField.textContentType = contentType
        }
        
        if let accentColor = accentColor {
            textField.tintColor = accentColor
        }
        
        textField.autocorrectionType = autocorrection
        textField.autocapitalizationType = autocapitalization
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        
        textField.clearsOnBeginEditing = clearsOnBeginEditing
        textField.isSecureTextEntry = isSecure
        textField.isUserInteractionEnabled = isUserInteractionEnabled
        
        if isEditing {
            textField.becomeFirstResponder()
        }
        
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        
        textField.accessibilityLabel = title
        
        textField.inputView = inputView
        
        if toolbar {
            
            let toolbar = UIToolbar()
            
            let clearTitle = AppStrings.Common.clearNumberText.capitalized
            
            let clearItem = UIBarButtonItem(
                title: clearTitle,
                style: .plain,
                target: context.coordinator,
                action: #selector(Coordinator.clearTextField)
            )
            
            let okItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: context.coordinator,
                action: #selector(Coordinator.dismissTextField)
            )
            
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            toolbar.setItems([clearItem, flexItem, okItem], animated: false)
            
            textField.inputAccessoryView = toolbar
            
            toolbar.sizeToFit()
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        
        uiView.text = text
        
        if isEditing {
            uiView.becomeFirstResponder()
            
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text,
                           isEditing: $isEditing,
                           didBeginEditing: didEndEditing,
                           didChange: didChange,
                           didEndEditing: didEndEditing)
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String {
            didSet {
                textField?.text = text
            }
        }
        
        @Binding var isEditing: Bool
        
        var didBeginEditing: () -> Void
        var didChange: () -> Void
        var didEndEditing: () -> Void
        
        weak var textField: UITextField?
        
        init(
            text: Binding<String>,
            isEditing: Binding<Bool>,
            didBeginEditing: @escaping () -> Void,
            didChange: @escaping () -> Void,
            didEndEditing: @escaping () -> Void
        ) {
            self._text = text
            self._isEditing = isEditing
            self.didBeginEditing = didBeginEditing
            self.didChange = didChange
            self.didEndEditing = didEndEditing
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            DispatchQueue.main.async {
                
                if !self.isEditing {
                    self.isEditing = true
                }
                
                self.didEndEditing()
            }
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            
            text = textField.text ?? ""
            
            didChange()
        }
        
        @objc func dismissTextField(_ button: UIBarButtonItem) {
            textField?.resignFirstResponder()
        }
        
        @objc func clearTextField(_ button: UIBarButtonItem) {
            text = ""
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            DispatchQueue.main.async {
                
                if self.isEditing {
                    self.isEditing = false
                }
                
                self.didEndEditing()
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            isEditing = false
            return false
        }
    }
}

extension TextFieldView {
    
    func appFont(weight: SwiftUI.Font.Weight, textStyle: UIFont.TextStyle) -> TextFieldView {
        
        typealias Family = FontFamily.Rubik
        
        let font: FontConvertible
        
        switch weight {
            
            case .black:
                font = Family.black
                
            case .bold, .heavy:
                font = Family.bold
                
            case .light, .thin, .ultraLight:
                font = Family.light
                
            case .medium:
                font = Family.medium
                
            case .regular:
                font = Family.regular
                
            case .semibold:
                font = Family.semiBold
                
            default:
                font = Family.regular
        }
        
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        var view = self
        
        view.font = UIFont(font: font, size: descriptor.pointSize)
        
        return view
    }
    
    func font(_ font: UIFont?) -> TextFieldView {
        
        var view = self
        
        view.font = font
        
        return view
    }
    
    func foregroundColor(_ color: ColorAsset) -> TextFieldView {
        
        var view = self
        view.foregroundColor = UIColor(asset: color)
        
        return view
    }
    
    func foregroundColor(_ color: UIColor?) -> TextFieldView {
        
        var view = self
        view.foregroundColor = color
        
        return view
    }
    
    func accentColor(_ accentColor: UIColor?) -> TextFieldView {
        
        var view = self
        view.accentColor = accentColor
        
        return view
    }
    
    func accentColor(_ color: ColorAsset) -> TextFieldView {
        
        var view = self
        view.accentColor = UIColor(asset: color)
        
        return view
    }
    
    func multilineTextAlignment(_ alignment: TextAlignment) -> TextFieldView {
        
        var view = self
        
        switch alignment {
            
            case .leading:
                view.textAlignment = layoutDirection ~= .leftToRight ? .left : .right
                
            case .trailing:
                view.textAlignment = layoutDirection ~= .leftToRight ? .right : .left
                
            case .center:
                view.textAlignment = .center
        }
        
        return view
    }
    
    func textContentType(_ textContentType: UITextContentType?) -> TextFieldView {
        
        var view = self
        view.contentType = textContentType
        
        return view
    }
    
    func disableAutocorrection(_ disable: Bool?) -> TextFieldView {
        
        var view = self
        
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
            
        } else {
            view.autocorrection = .default
        }
        
        return view
    }
    
    func autocapitalization(_ style: UITextAutocapitalizationType) -> TextFieldView {
        var view = self
        view.autocapitalization = style
        return view
    }
    
    func keyboardType(_ type: UIKeyboardType) -> TextFieldView {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func returnKeyType(_ type: UIReturnKeyType) -> TextFieldView {
        var view = self
        view.returnKeyType = type
        return view
    }
    
    func isSecure(_ isSecure: Bool) -> TextFieldView {
        var view = self
        view.isSecure = isSecure
        return view
    }
    
    func clearsOnBeginEditing(_ shouldClear: Bool) -> TextFieldView {
        var view = self
        view.clearsOnBeginEditing = shouldClear
        return view
    }
    
    func disabled(_ disabled: Bool) -> TextFieldView {
        var view = self
        view.isUserInteractionEnabled = disabled
        return view
    }
    
    func proportionalInputView(viewModel: InputPickerViewModelProtocol?) -> TextFieldView {
        
        guard let viewModel = viewModel else {
            return self
        }
        
        var view = self
        
        let picker = InputPickerView(viewModel: viewModel)
        
        view.inputView = picker
        
        return view
    }
}
