//
//  MainTabView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import SwiftUI

struct MainTabView: View {
    @SceneStorage("selectedTab") private var selectedTabIndex = 0
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView {
            HomeView(coordinator: coordinator)
                .tabItem {
                    Label("Home", systemImage: selectedTabIndex == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            ProfileView(coordinator: coordinator)
                .tabItem {
                    Label("Profile", systemImage: selectedTabIndex == 1 ? "person.fill" : "person")
                }
                .tag(1)
        }
    }
}

#Preview {
    MainTabView()
}
