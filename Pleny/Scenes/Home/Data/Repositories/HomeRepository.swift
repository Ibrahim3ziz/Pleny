//
//  HomeRepository.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import Combine
import NetworkKit

protocol HomeRepositoryInterface: AnyObject {
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError>
    func searchPosts(query: String) -> AnyPublisher<PostsResponse, NetworkError>
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError>
    func saveCurrentPosts(_ posts: Posts?)
}

final class HomeRepository: HomeRepositoryInterface {
    private let remoteDataSource: HomeRemoteDataSourceInterface
    private let localDataSource: HomeLocalDataSourceInterface
    
    init(remoteDataSource: HomeRemoteDataSourceInterface = HomeRemoteDataSource(),
         localDataSource: HomeLocalDataSourceInterface = HomeLocalDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError> {
        remoteDataSource.fetchPosts()
    }
    
    func searchPosts(query: String) -> AnyPublisher<PostsResponse, NetworkError> {
        remoteDataSource.searchPost(query: query)
    }
    
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError> {
        localDataSource.getCachedPosts()
    }
    
    func saveCurrentPosts(_ posts: Posts?) {
        localDataSource.saveCurrentPosts(posts)
    }
}
