//
//  SerachTextField.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import SwiftUI

struct SerachTextField: View {
    
    var placeholder: String
    @Binding var searchText: String
    var leadingIcon: String
    var trailingIcon: String
    var keyboardType: UIKeyboardType = .default
    var cancelAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(leadingIcon)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.leading, 12)
                
                TextField(placeholder, text: $searchText)
                    .keyboardType(keyboardType)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 0)
                
                Button {
                    searchText = "" // reset search
                    cancelAction?()
                } label: {
                    Image(trailingIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 12)
                }
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

#Preview {
    SerachTextField(placeholder: "Search", searchText: .constant("Food"), leadingIcon: "icon-home-search", trailingIcon: "icon-searchbar-cancel", keyboardType: .default) {
        print(">>> Cancel Action <<<")
    }
}
