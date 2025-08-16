//
//  HomeViewModel.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import Foundation
import NetworkKit
import Combine

final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private var cancellables = Set<AnyCancellable>()
    private let useCase: HomeUseCaseInterface
    
    // MARK: - Published Outputs
    @Published var posts: [PostEntity] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkError?
    @Published var isSearching: Bool = false
    @Published var searchText: String = ""
    
    // MARK: - Private Properties
    private var cachedPosts: [PostEntity] = [] // Store cached posts
    private var networkMonitor = NetworkMonitor()
    private let coordinator: AppCoordinatorProtocol?
        
    init(useCase: HomeUseCaseInterface = HomeUseCase(),
         bindSearch: Bool = true,
         coordinator: AppCoordinatorProtocol?
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        if bindSearch {
            $searchText
                .removeDuplicates()
                .sink { [weak self] text in
                    guard let self else { return }
                    
                    if text.isEmpty {
                        getPosts()
                    } else if text.count >= 2 {
                        switch networkMonitor.status {
                        case .connected:
                            searchPosts()
                        case .disconnected:
                            fetchCachedPosts()
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func getPosts() {
        isLoading = true
        error = nil
        
        fetchCachedPosts()
        
        useCase.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                isLoading = false
                if case let .failure(err) = completion {
                    self.error = err
                }
            } receiveValue: { [weak self] entity in
                self?.posts = entity.posts
                let savedPosts = entity.posts.compactMap({ entity in
                    return Post(domain: entity)
                })
                self?.useCase.saveCurrentPosts(Posts(posts: savedPosts))
            }
            .store(in: &cancellables)
    }
    
    func searchPosts() {
        isLoading = true
        isSearching = true
        error = nil
        useCase.searchPosts(query: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                isLoading = false
                isSearching = false
                // TODO: - need to handle the failure
                if case let .failure(err) = completion {
                    print("Network status: \(networkMonitor.status)")
                    switch networkMonitor.status {
                    case .connected:
                        self.error = err
                    case .disconnected:
                        self.error = nil
                    }
                }
            } receiveValue: { [weak self] entity in
                self?.posts = entity.posts
            }
            .store(in: &cancellables)
    }
    
    func fetchCachedPosts() {
        isLoading = true
        error = nil
        
        useCase.getCachedPosts()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(cacheError) = completion {
                    print("⚠️ Failed to load cached posts: \(cacheError.localizedDescription)")
                }
            } receiveValue: { [weak self] cachedPosts in
                guard let self else { return }
                isLoading = false
                print("📦 Loaded \(cachedPosts.count) cached posts")
                let postEntities = cachedPosts.map { cachedPost in
                    return cachedPost.toEntity()
                }
                self.posts = postEntities
            }
            .store(in: &cancellables)
    }
}
