//
//  ProfileHeader.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 16/08/2025.
//

import SwiftUI

struct ProfileHeader: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("profile_icon")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("01010101010")
                .font(.caption)
            
            Text("Ibrahim Abdul Aziz")
                .font(.headline)
            
            Button("Edit Profile", systemImage: "square.and.pencil") {
                
            }
            .foregroundStyle(Color.foundationMainPrimary)
        }
    }
}

#Preview {
    ProfileHeader()
}
