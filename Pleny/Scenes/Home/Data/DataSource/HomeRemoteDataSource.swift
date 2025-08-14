//
//  HomeRemoteDataSource.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import Combine
import NetworkKit

protocol HomeRemoteDataSourceInterface: AnyObject {
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError>
    func searchPost(query: String) -> AnyPublisher<PostsResponse, NetworkError>
}

final class HomeRemoteDataSource: HomeRemoteDataSourceInterface {
    private let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func fetchPosts() -> AnyPublisher<PostsResponse, NetworkError> {
        networkService.execute(FeedRequest(), model: PostsResponse.self)
    }
    
    func searchPost(query: String) -> AnyPublisher<PostsResponse, NetworkError> {
        networkService.execute(SearchRequest(query: query), model: PostsResponse.self)
    }
}
