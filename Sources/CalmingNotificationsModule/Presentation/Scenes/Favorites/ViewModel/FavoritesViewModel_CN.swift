//
//  FavoritesViewModel_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import MommysEye


protocol FavoritesViewModelProtocol_CN {
    func viewDidLoad()
    func dismissButtonTapped()
    var quoteCards: Publisher<[QuoteCard_CN]> { get }
    var isLoading: Publisher<Loading_CN> { get }
    var showSuccessAnimation: Publisher<Bool> { get }
    var error: Publisher<String> { get }
}

protocol FavoritesCellViewModelProtocol_CN {
    func likeButtonTapped(cellWithIndex: Int)
    func shareButtonTapped(cellWithIndex: Int)
}


final class FavoritesViewModel_CN: FavoritesViewModelProtocol_CN,
                                   FavoritesCellViewModelProtocol_CN {
    
    // MARK: - Dependencies
    
    private let router: FavoritesRouterProtocol_CN
    private let quoteCardRepository: QuoteCardGateway_CN
    private let errorHandler: FavoritesErrorHandlerProtocol_CN
    
    
    // MARK: - Init
    
    init(router: FavoritesRouterProtocol_CN,
         quoteCardRepository: QuoteCardGateway_CN,
         errorHandler: FavoritesErrorHandlerProtocol_CN) {
        self.router = router
        self.quoteCardRepository = quoteCardRepository
        self.errorHandler = errorHandler
//        loadInitialState()
    }
    
    
    // MARK: - State
    
    var quoteCards = Publisher(value: [QuoteCard_CN]())
    var isLoading = Publisher(value: Loading_CN.false)
    var showSuccessAnimation = Publisher(value: false)
    var error = Publisher(value: "")
    
    
    // MARK: - Private state
    
    private var quoteTask: Task<Void, Error>? {
        willSet {
            self.quoteTask?.cancel()
        }
    }
    
    
    // MARK: - Interface
    
    func viewDidLoad() {
        isLoading.value = .true
        quoteTask = Task {
            do {
                let result = try await quoteCardRepository.fetchFavorites()
                self.quoteCards.value = result
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
            self.isLoading.value = .false
        }
    }
    
    private func loadInitialState() {
        quoteTask = Task {
            let result = try await quoteCardRepository.fetchFavorites()
    //        print(result.count)
            self.quoteCards.value = result
        }
    }
    
    func dismissButtonTapped() {
        router.dismissButtonTapped()
    }
    
    func likeButtonTapped(cellWithIndex: Int) {
        switch quoteCards.value[cellWithIndex].isFavorite {
        case false:
            quoteTask = Task {
                do {
                    var quoteCard = self.quoteCards.value[cellWithIndex]
                    quoteCard.isFavorite = true
                    try await self.quoteCardRepository.saveFavorite(quoteCard)
                    self.quoteCards.value[cellWithIndex] = quoteCard
                } catch let domainError {
                    let sceneError = self.errorHandler.handle(domainError)
                    self.handle(sceneError)
                }
            }
        case true:
            quoteTask = Task {
                do {
                    var quoteCard = self.quoteCards.value[cellWithIndex]
                    quoteCard.isFavorite = false
                    try await self.quoteCardRepository.deleteFavorite(quoteCard)
                    self.quoteCards.value[cellWithIndex] = quoteCard
                } catch let domainError {
                    let sceneError = self.errorHandler.handle(domainError)
                    self.handle(sceneError)
                }
            }
        }
        
    }
    
    func shareButtonTapped(cellWithIndex index: Int) {
        let quoteCard = quoteCards.value[index]
        let setup = QuoteCardWallPaperDrawSetup_CN.standart.setup(for: quoteCard.image)
        guard let quoteCardImage = quoteCard.image.drawTextOnImage(
            text: quoteCard.quote,
            textAttributes: setup.textAttributes,
            textFrame: setup.textFrame) else { return }
        router.shareButtonTapped(with: quoteCardImage) { [weak self] toAnimate in
            self?.showSuccessAnimation.value = toAnimate
        }
    }
    
    
    // MARK: - Private

    private func handle(_ sceneError: FavoritesSceneError_CN) {
        let errorMessage = sceneError.message
        error.value = errorMessage
        // there are no action cases yet
        guard let _ = sceneError.action else { return }
    }
    
    
    deinit {
        //        print("deinit FavoritesViewModel_CN")
    }
}
