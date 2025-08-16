//
//  AuthViewModel.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import Foundation
import NetworkKit
import Combine

final class AuthViewModel: ObservableObject {
    // MARK: - Dependencies
    private var cancellables = Set<AnyCancellable>()
    private let useCase: AuthUseCaseInterface
    private let coordinator: AppCoordinatorProtocol?
    
    // MARK: - Published Outputs
    @Published var user: UserEntity?
    @Published var isLoading: Bool = false
    @Published var error: NetworkError?
    
    init(useCase: AuthUseCaseInterface = AuthUseCase(),
         coordinator: AppCoordinatorProtocol? = nil
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func login(username: String, password: String) {
        isLoading = true
        error = nil
        if UserDefaults.standard.bool(forKey: Constants.isUserLoggedIn) == true { // Check if the user is logged in.
            if let userData = KeyChain.read(objectType: UserEntity.self, key: Constants.userSession) { // Retrieve the user data.
                coordinator?.navigateToMainFlow(with: userData)
            }
        } else {
            useCase.login(body: UserBody(username: username, password: password))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    isLoading = false
                    if case let .failure(err) = completion {
                        self.error = err
                    }
                } receiveValue: { [weak self] user in
                    self?.user = user
                    UserDefaults.standard.setValue(true, forKey: Constants.isUserLoggedIn) // Make the user logged in.
                    KeyChain.save(object: user, key: Constants.userSession) // Save the userEntity in the keyChain.
                    self?.coordinator?.navigateToMainFlow(with: user)
                }.store(in: &cancellables)
        }
    }
}
