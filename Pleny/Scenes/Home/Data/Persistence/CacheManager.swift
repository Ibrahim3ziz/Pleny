//
//  CacheManager.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import Foundation
import CoreData

protocol CacheManagerInterface {
    var managedObjectContext: NSManagedObjectContext { get }
    func saveContext() throws
    func retrieve<T: NSManagedObject>(_ type: T.Type) throws -> [T]
}

enum CacheDataError: Error {
    case onSaveError(Error)
    case onReadError(Error)
    case onDeleteError(Error)
    case onError(String)
    
    var localizedDescription: String {
        switch self {
        case .onSaveError(let error),
                .onReadError(let error),
                .onDeleteError(let error):
            return error.localizedDescription
        case .onError(let message):
            return message
        }
    }
}

final class CacheManager: CacheManagerInterface {
    
    static let shared = CacheManager()
    
    private init() {}
    
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataCacheModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() throws {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ data saved successfully to Core Data.")
            } catch {
                throw CacheDataError.onSaveError(error)
            }
        }
    }
    
    func retrieve<T: NSManagedObject>(_ type: T.Type) throws -> [T] {
        let request = T.fetchRequest()
        guard let typedRequest = request as? NSFetchRequest<T> else {
            throw CacheDataError.onError("Invalid fetch request for \(T.self)")
        }
        return try managedObjectContext.fetch(typedRequest)
    }
}
