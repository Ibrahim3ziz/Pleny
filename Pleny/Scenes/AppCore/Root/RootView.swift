//
//  RootView.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject var coordinator = AppCoordinator()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .auth:
                if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) == true {
                    MainTabView()
                } else {
                    AuthView(coordinator: coordinator)
                }
            case .main:
                MainTabView()
            case .profile:
                ProfileView(coordinator: coordinator)
            }
        }
        .environmentObject(coordinator)
        .environmentObject(networkMonitor)
    }
}
