//
//  OptionListHelperComponents.swift
//  OptionListInSwiftUI
//
//  Created by GWL on 23/01/24.
//

import SwiftUI
import UIKit
struct CustomButton: View {
    var text: String
    var action: () -> Void
    var height: CGFloat?
    var horizontalPadding: CGFloat?
    var width: CGFloat?
    var fontSize: CGFloat?
    var radius: CGFloat?
    var isDisabled: Bool = false
    var isTextButton: Bool = false
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text)
                    .font(Font.subheadline).bold()
                    .foregroundColor(isTextButton ? .blue : .white)
                    .padding(
                        EdgeInsets(
                            top: 10,
                            leading: 10,
                            bottom: 10,
                            trailing: 10
                        )
                    )
                Spacer()
            }
            // inside the `Button`
            .frame(height: height, alignment: .center)
            .cornerRadius(radius ?? 12)
            .buttonStyle(PlainButtonStyle())
            .background(
                RoundedRectangle(cornerRadius: radius ?? 12)
                    .fill(
                        isTextButton ? .white : isDisabled ? .gray : .blue
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius ?? 12)
                    .strokeBorder(
                        isTextButton ? .blue : .clear,
                        lineWidth: 1
                    )
                    .frame(height: height)
            )}.disabled(self.isDisabled)
    }
}
// Textfield focus state management:
struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String
    @Binding public var isSecured: Bool
    var isForSearchScreen: Bool = false
    var isEmailField: Bool = false
    public var configuration = { (_: UITextField) in }
    var returnKeyType: UIReturnKeyType = .default
    public init(text: Binding<String>,
                isFirstResponder: Binding<Bool>, isSecured: Binding<Bool>,
                configuration: @escaping (UITextField) -> Void = { _ in },
                returnKeyType: UIReturnKeyType? = .default,
                isForSearchScreen: Bool = false,
                isEmailField: Bool = false
    ) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
        self._isSecured = isSecured
        self.returnKeyType = returnKeyType ?? .default
        self.isForSearchScreen = isForSearchScreen
        self.isEmailField = isEmailField
    }
    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.isSecureTextEntry = self.isSecured
        view.keyboardType = .default
        if isEmailField {
            view.autocorrectionType = .no
            view.autocapitalizationType = .none
            view.keyboardType = .emailAddress
        }
        if returnKeyType == .search {
            view.returnKeyType = .search
        }
        if isForSearchScreen {
            view.autocorrectionType = .no
        }
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange),
                       for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }
    public func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
            uiView.text = text
            configuration(uiView)
            switch isFirstResponder {
            case true:
                DispatchQueue.main.async {
                    uiView.becomeFirstResponder()
                }
            case false:
                DispatchQueue.main.async {
                    uiView.resignFirstResponder()
                }
            }
        }
    }
    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }
    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>
        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }
        @objc public func textViewDidChange(_ textField: UITextField) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.text.wrappedValue = textField.text ?? "---"
            }
        }
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }
        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func showKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
}
