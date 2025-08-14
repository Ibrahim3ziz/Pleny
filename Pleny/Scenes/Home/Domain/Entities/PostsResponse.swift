//
//  Posts.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 28/06/2025.
//

import Foundation

// MARK: - Post response
struct PostsResponse: Codable {
    let posts: [PostEntity]
    let total, skip, limit: Int
}

// MARK: - PostEntity
struct PostEntity: Codable {
    let id: Int
    let title, body: String
    let tags: [String]
    let reactions: Reactions
    let views, userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, body, tags, reactions, views
        case userID = "userId"
    }
}

// MARK: - Reactions
struct Reactions: Codable {
    let likes, dislikes: Int
}
