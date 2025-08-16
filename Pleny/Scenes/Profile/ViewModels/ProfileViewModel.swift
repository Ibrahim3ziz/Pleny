//
//  ProfileViewModel.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 16/08/2025.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    private let coordinator: AppCoordinatorProtocol?
    
    init(coordinator: AppCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: Constants.isUserLoggedIn)
        KeyChain.delete(key: Constants.userSession)
        navigateToAuth()
    }
    
    private func navigateToAuth() {
        coordinator?.navigateToAuthFlow()
    }
}
