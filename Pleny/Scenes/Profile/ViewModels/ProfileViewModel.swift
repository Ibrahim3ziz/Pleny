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
    
}
