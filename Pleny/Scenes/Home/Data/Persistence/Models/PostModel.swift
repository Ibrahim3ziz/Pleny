//
//  PostModel.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 11/07/2025.
//

import Foundation
import CoreData

struct Posts: Codable {
    var posts: [Post]
    
    func toCDEntity(in context: NSManagedObjectContext) -> CDPostEntity {
        var entity: CDPostEntity = .init(context: context)
        posts.forEach { model in
            entity = CDPostEntity(context: context)
            entity.title = model.title
            entity.body = model.body
            entity.tags = model.tags as NSObject
            entity.likes = Int64(model.likes)
            entity.dislikes = Int64(model.dislikes)
            entity.id = Int64(model.userID)
        }
        return entity
    }
}

struct Post: Codable, Hashable, Identifiable {
    var id = UUID()
    
    var title: String
    var body: String
    var tags: [String]
    var likes: Int
    var dislikes: Int
    var userID: Int
    
    init(domain entity: PostEntity) {
        title = entity.title
        body = entity.body
        tags = entity.tags
        likes = entity.userID
        dislikes = entity.userID
        userID = entity.userID
    }
    
    init(coreData entity: CDPostEntity) {
        title = entity.title ?? ""
        body = entity.body ?? ""
        tags = (entity.tags as? [String]) ?? []
        likes = Int(entity.likes)
        dislikes = Int(entity.dislikes)
        userID = Int(entity.id)
    }
}

extension Post {
    func toEntity() -> PostEntity {
        return PostEntity(
            id: Int(userID),
            title: title,
            body: body,
            tags: tags,
            reactions: Reactions(likes: likes, dislikes: dislikes),
            views: 0,
            userID: userID
        )
    }
}
