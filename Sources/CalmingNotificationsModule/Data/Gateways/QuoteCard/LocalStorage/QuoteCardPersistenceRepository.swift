//
//  QuoteCardPersistenceRepositoryProtocol_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import CoreData


protocol QuoteCardPersistenceRepositoryProtocol_CN {
    func fetchFavorites() async throws -> [QuoteCardDBEntity]
    func saveFavorite(_ quoteCard: QuoteCard_CN) async throws
    func deleteFavorite(_ quoteCard: QuoteCard_CN) async throws
}


final class QuoteCardPersistenceRepository: QuoteCardPersistenceRepositoryProtocol_CN {
    
    // MARK: - Dependencies
    
    private let coreDataContainer = CoreDataStack_CN.shared.persistentContainer
    
    
    // MARK: - Interface
    
    func fetchFavorites() async throws -> [QuoteCardDBEntity] {
        let request: NSFetchRequest = QuoteCardDBEntity.fetchRequest()
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            return fetchResult
        } catch let error {
            throw QuoteCardLocalStorageError.generic(error)
        }
    }
    
    func saveFavorite(_ quoteCard: QuoteCard_CN) async throws {
        let dbEntity = QuoteCardDBEntity.init(context: coreDataContainer.viewContext)
        try dbEntity.parseToDBEntity(domain: quoteCard)
        do {
            try coreDataContainer.viewContext.save()
        } catch let error {
            throw QuoteCardLocalStorageError.generic(error)
        }
    }
    
    func deleteFavorite(_ quoteCard: QuoteCard_CN) async throws {
        let request: NSFetchRequest = QuoteCardDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quoteCard.id as NSUUID)
        do {
            if let fetchResult = try coreDataContainer.viewContext.fetch(request).first {
                coreDataContainer.viewContext.delete(fetchResult)
                try coreDataContainer.viewContext.save()
            }
        } catch let error {
            throw QuoteCardLocalStorageError.generic(error)
        }
    }
    
    
    deinit {
        //        print("QuoteCardPersistenceRepository is deinit -------- ")
    }
}


enum QuoteCardLocalStorageError: Error {
    case generic(Error)
    case failureToDBEntityMapping(String)
    case failureToDomainEntityMapping(String)
}
