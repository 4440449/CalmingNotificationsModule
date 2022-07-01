//
//  QuoteCardRepository_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit
import Foundation
import BabyNet


final class QuoteCardRepository_CN: QuoteCardGateway_CN {
    
    // MARK: - Dependencies
    
    private let network: QuoteCardNetworkRepositoryProtocol_CN
    private let localStorage: QuoteCardPersistenceRepositoryProtocol_CN
    private let errorHandler: DomainErrorHandlerProtocol_CN
    private var quoteCardState: QuoteCardStateProtocol_CN
    
    
    // MARK: - Init
    
    init(network: QuoteCardNetworkRepositoryProtocol_CN,
         localStorage: QuoteCardPersistenceRepositoryProtocol_CN,
         errorHandler: DomainErrorHandlerProtocol_CN,
         quoteCardState: QuoteCardStateProtocol_CN) {
        self.network = network
        self.localStorage = localStorage
        self.errorHandler = errorHandler
        self.quoteCardState = quoteCardState
    }
    
    
    // MARK: - Interface
    
    func getState() -> QuoteCardStateProtocol_CN {
        return quoteCardState
    }
    
    func setState(taskProgressCallback: @escaping (Progress) -> ()) async throws {
        let networkCards = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[QuoteCardNetworkEntity_CN], Error>) -> Void in
            let _ = self.network.fetch (callback: { result in //networkTask
                switch result {
                case let .success(networkCards):
                    continuation.resume(returning: networkCards)
                case let .failure(networkError):
                    let domainError = self.errorHandler.handle(networkError)
                    continuation.resume(throwing: domainError)
                }
            }, taskProgressCallback: taskProgressCallback)
        }
        do {
            var domains = try networkCards.map { try $0.parseToDomain() }
            
            let favorites = try await localStorage.fetchFavorites()
            let favoriteDomains = try favorites.map { try $0.parseToDomainEntity() }
            for favorite in favoriteDomains {
                for (index, domain) in domains.enumerated() {
                    if favorite == domain {
                        domains[index].isFavorite = favorite.isFavorite
                    }
                }
            }
            quoteCardState.quoteCards.value = domains
            let quotes = domains.map { $0.quote }
            quoteCardState.quotes.value = quotes
//            throw BabyNetError.badResponse("hello")
//            throw BabyNetError.badRequest(URLError.init(.notConnectedToInternet))
//            throw QuoteCardLocalStorageError.failureToDBEntityMapping("")
        } catch let dataError {
            let domainError = errorHandler.handle(dataError)
            throw domainError
        }
    }
    
    func fetchFavorites() async throws -> [QuoteCard_CN] {
        let result = try await localStorage.fetchFavorites()
        let domain = try result.map { try $0.parseToDomainEntity() }
        return domain
    }
    
    func saveFavorite(_ quoteCard: QuoteCard_CN) async throws{
        try await localStorage.saveFavorite(quoteCard)
        for (index, card) in quoteCardState.quoteCards.value.enumerated() {
            if card.id == quoteCard.id {
                quoteCardState.quoteCards.value[index].isFavorite = true
            }
        }
    }
    
    func deleteFavorite(_ quoteCard: QuoteCard_CN) async throws {
        try await localStorage.deleteFavorite(quoteCard)
        for (index, card) in quoteCardState.quoteCards.value.enumerated() {
            if card.id == quoteCard.id {
                quoteCardState.quoteCards.value[index].isFavorite = false
            }
        }
    }
    
    
    deinit {
        //        print("QuoteCardRepository_CN is deinit -------- ")
    }
}
