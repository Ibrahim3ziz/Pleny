//
//  ProfileView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 15/08/2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .center) {
            
            ProfileHeader()
            
            Spacer(minLength: 40)
            
            Divider()
            
            Spacer(minLength: 16)
            
            List {
                Section {
                    HStack {
                        Image("ic_outlined_envelopeopen")
                            .frame(width: 16, height: 16)
                        
                        Text("Email")
                        Spacer()
                        Text("ibrahim@example.com")
                    }
                    
                    HStack {
                        Image("user")
                            .frame(width: 16, height: 16)
                        
                        Text("Phone Number")
                        Spacer()
                        Text("+201010101010")
                    }
                    
                    HStack {
                        Image("ic_outlined_globe")
                            .frame(width: 16, height: 16)
                        
                        Text("Language")
                        Spacer()
                        
                        Button {
                            // action
                        } label: {
                            HStack {
                                Text("Arabic")
                                    .padding(.trailing, 0)
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Color.foundationMainPrimary)
                        }
                        
                    }
                    
                    HStack {
                        Image("ic_outlined_padlock")
                            .frame(width: 16, height: 16)
                        
                        Text("Change Password")
                        Spacer()
                        Button("" ,systemImage: "chevron.right") {
                            
                        }
                        .padding(.trailing, -16)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.foundationMainPrimary)
                    }
                    
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            HStack {
                Image("logout_icon")
                    .frame(width: 24, height: 24)
                
                Text("Logout")
                    .foregroundStyle(.black)
                
                Spacer()
            }
            .padding(.leading, 8)
            .frame(height: 60, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 4)
        .background(Color.white)
    }
}

#Preview {
    ProfileView()
}
