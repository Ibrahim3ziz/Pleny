//
//  SimpleInputField.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import SwiftUI

struct SimpleInputField: View {
    var title: String
    var placeholder: String
    var leadingIcon: String?
    var trailingIcon: String?
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String
    var isSecureTextEntry: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 16)
            
            HStack {
                if let leadingIcon {
                    Image(leadingIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.leading, 12)
                }
                
                Group {
                    if isSecureTextEntry && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .keyboardType(keyboardType)
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 14)
                
                if isSecureTextEntry {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(isPasswordVisible ? "icon-textfield-showPassword" : "icon-textfield-showPassword") // here change the icon
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 12)
                    }
                } else if let trailingIcon {
                    Image(trailingIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 12)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("lightGrayColor"), lineWidth: 1)
            )
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SimpleInputField(title: "Username", placeholder: "Enter your username", text: .constant(""), isSecureTextEntry: false)
    
    SimpleInputField(title: "Password", placeholder: "Enter your password", trailingIcon: "icon-textfield-showPassword", keyboardType: .default, text: .constant(""), isSecureTextEntry: true)
}
