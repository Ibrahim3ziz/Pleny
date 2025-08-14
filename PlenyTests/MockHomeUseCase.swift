//
//  MockHomeUseCase.swift
//  PlenyTests
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import Combine
import NetworkKit
@testable import Pleny

// MARK: - Mock Use Case
final class MockHomeUseCase: HomeUseCaseInterface {
    
    var fetchPostsResult: AnyPublisher<Pleny.PostsResponse, NetworkKit.NetworkError> =
    Just(PostsResponse(posts: [], total: 0, skip: 0, limit: 0))
        .setFailureType(to: NetworkKit.NetworkError.self)
        .eraseToAnyPublisher()
    
    var searchPostsResult: AnyPublisher<Pleny.PostsResponse, NetworkKit.NetworkError> =
    Just(PostsResponse(posts: [], total: 0, skip: 0, limit: 0))
        .setFailureType(to: NetworkKit.NetworkError.self)
        .eraseToAnyPublisher()
    
    var cachedPostsResult: AnyPublisher<[Pleny.Post], Pleny.CacheDataError> =
    Just([Post(domain: PostEntity(id: 0, title: "Mock Title", body: "Mock Body", tags: [], reactions: Reactions(likes: 0, dislikes: 0), views: 0, userID: 0))])
        .setFailureType(to: Pleny.CacheDataError.self)
        .eraseToAnyPublisher()
    
    var savedPosts: Pleny.Posts? = Posts(posts: [])
    
    
    func fetchPosts() -> AnyPublisher<Pleny.PostsResponse, NetworkKit.NetworkError> {
        fetchPostsResult
    }
    
    func searchPosts(query: String) -> AnyPublisher<Pleny.PostsResponse, NetworkKit.NetworkError> {
        searchPostsResult
    }
    
    func getCachedPosts() -> AnyPublisher<[Pleny.Post], Pleny.CacheDataError> {
        cachedPostsResult
    }
    
    func saveCurrentPosts(_ posts: Pleny.Posts?) {
        savedPosts = posts
    }
}
