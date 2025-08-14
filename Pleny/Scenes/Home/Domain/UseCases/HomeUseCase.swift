//
//  HomeUseCase.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 29/06/2025.
//

import NetworkKit
import Combine

protocol HomeUseCaseInterface: AnyObject {
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError>
    func searchPosts(query: String) -> AnyPublisher<PostsResponse, NetworkError>
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError>
    func saveCurrentPosts(_ posts: Posts?)
}

final class HomeUseCase: HomeUseCaseInterface {
    private let repository: HomeRepositoryInterface
    private var cancellable = Set<AnyCancellable>()
    
    init(repository: HomeRepositoryInterface = HomeRepository()) {
        self.repository = repository
    }
    
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError> {
        repository.fetchPosts()
    }
    
    func searchPosts(query: String) -> AnyPublisher<PostsResponse, NetworkError> {
        repository.searchPosts(query: query)
    }
    
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError> {
        repository.getCachedPosts()
    }
    
    func saveCurrentPosts(_ posts: Posts?)  {
        repository.saveCurrentPosts(posts)
    }
}
