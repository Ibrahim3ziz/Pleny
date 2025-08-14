//
//  PlenyTests.swift
//  PlenyTests
//
//  Created by Ibrahim Abdul Aziz on 27/06/2025.
//

import XCTest
import Combine
import NetworkKit
@testable import Pleny

final class PlenyTests: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var mockUseCase: MockHomeUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUseCase = MockHomeUseCase()
        viewModel = HomeViewModel(useCase: mockUseCase, bindSearch: false)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        mockUseCase = nil
        viewModel = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Success
    func test_getPosts_success_shouldUpdatePosts() {
        // Given
        let expectedPosts = [
            PostEntity(
                id: 1,
                title: "Test",
                body: "Hello",
                tags: ["news"],
                reactions: Reactions(likes: 10, dislikes: 1),
                views: 100,
                userID: 1),
            PostEntity(
                id: 2,
                title: "Another",
                body: "World",
                tags: ["tech"],
                reactions: Reactions(likes: 5, dislikes: 0),
                views: 50,
                userID: 2
            )
        ]
        
        let response = PostsResponse(
            posts: expectedPosts,
            total: 2,
            skip: 0,
            limit: 10
        )
        
        mockUseCase.fetchPostsResult = Just(response)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Posts updated")
        
        // When
        viewModel.$posts
            .dropFirst()
            .sink { posts in
                XCTAssertEqual(posts.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getPosts()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_saveCurrentPosts_savesSuccessfully() {
        // Given
        let expectedPost = Post(domain: PostEntity(id: 1,
                                                   title: "Cached",
                                                   body: "This is cached",
                                                   tags: [""],
                                                   reactions: Reactions(likes: 0, dislikes: 0),
                                                   views: 0,
                                                   userID: 1))
        let posts = Posts(posts: [expectedPost])
        
        // When
        mockUseCase.saveCurrentPosts(posts)
        
        // Then
        XCTAssertEqual(mockUseCase.savedPosts?.posts.count, 1)
        XCTAssertEqual(mockUseCase.savedPosts?.posts.first?.title, "Cached")
    }
    
    // MARK: - Performance (Optional)
    func testPerformanceExample() throws {
        mockUseCase.fetchPostsResult = Just(PostsResponse(posts: [], total: 0, skip: 0, limit: 10))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        
        measure {
            let expectation = XCTestExpectation(description: "Wait for posts")
            
            viewModel.$posts
                .dropFirst()
                .sink { _ in
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.getPosts()
            wait(for: [expectation], timeout: 1.0)
        }
    }
}
