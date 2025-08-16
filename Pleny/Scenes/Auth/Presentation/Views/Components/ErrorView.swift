//
//  ErrorView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 16/08/2025.
//

import SwiftUI

struct ErrorView: View {
    @State private var isPresented: Bool = true
    let title: String
    let message: String
    
    var body: some View {
        Color.clear
            .alert(title, isPresented: $isPresented) {
                
            } message: {
                Text(message)
            }
    }
}

#Preview {
    ErrorView(title: "Somwthing went wrong", message: "Please try again later.")
}
