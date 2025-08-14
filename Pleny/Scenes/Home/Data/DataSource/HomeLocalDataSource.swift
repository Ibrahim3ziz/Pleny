//
//  HomeLocalDataSource.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 30/06/2025.
//

import Combine
import CoreData

// MARK: - Protocol
protocol HomeLocalDataSourceInterface: AnyObject {
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError>
    func saveCurrentPosts(_ posts: Posts?)
}

// MARK: - Implementation
final class HomeLocalDataSource: HomeLocalDataSourceInterface {
    
    private let localService: CacheManagerInterface
    
    init(localService: CacheManagerInterface = CacheManager.shared) {
        self.localService = localService
    }
    
    func getCachedPosts() -> AnyPublisher<[Post], CacheDataError> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(CacheDataError.onError("error occurred")))
                return
            }
            let request = NSFetchRequest<CDPostEntity>(entityName: "CDPostEntity")
            do {
                let cachedPosts = try localService.managedObjectContext.fetch(request)
                print("cached data retrieved", cachedPosts.count)
                let posts = cachedPosts.map({Post(coreData: $0)})
                promise(.success(posts))
            }
            catch {
                promise(.failure(CacheDataError.onError(error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveCurrentPosts(_ posts: Posts?) {
        guard let posts else { return }
        let context = localService.managedObjectContext
        let _ = posts.toCDEntity(in: context)
        do {
            try context.save()
            print("✅ Posts saved successfully to Core Data.")
        } catch {
            print("Failed to save posts: \(error.localizedDescription)")
        }
    }
}
