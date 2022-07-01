//
//  MainViewModel_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import MommysEye
import UIKit


protocol MainViewModelProtocol_CN {
    func viewDidLoad()
    func menuButtonTapped()
    var quoteCards: Publisher<[QuoteCard_CN]> { get }
    var isLoading: Publisher<Loading_CN> { get }
    var showSuccessAnimation: Publisher<Bool> { get }
    var error: Publisher<String> { get }
}

protocol MainCellViewModelProtocol_CN {
    func likeButtonTapped(cellWithIndex: Int)
    func shareButtonTapped(cellWithIndex index: Int)
}


final class MainViewModel_CN: MainViewModelProtocol_CN,
                              MainCellViewModelProtocol_CN {
    
    // MARK: - Dependencies
    
    private let quoteCardRepository: QuoteCardGateway_CN
    private let router: MainRouterProtocol_CN
    private let errorHandler: MainErrorHandlerProtocol_CN
    
    init(quoteCardRepository: QuoteCardGateway_CN,
        router: MainRouterProtocol_CN,
        errorHandler: MainErrorHandlerProtocol_CN) {
            //         quoteCards: [QuoteCard_CN]) {
            self.quoteCardRepository = quoteCardRepository
            //        self.quoteCards.value = quoteCards
            self.router = router
            self.errorHandler = errorHandler
        }
    
    // MARK: - State
    
    var quoteCards = Publisher(value: [QuoteCard_CN]())
    var isLoading = Publisher(value: Loading_CN.false)
    var showSuccessAnimation = Publisher(value: false)
    var error = Publisher(value: String())
    
    
    // MARK: - Private state
    
    private var quoteTask: Task<Void, Error>? {
        willSet {
            self.quoteTask?.cancel()
        }
    }
    
    
    // MARK: - Interface
    
    func viewDidLoad() {
        let state = quoteCardRepository.getState()
        quoteCards.value = state.quoteCards.value
        setupObservers()
    }
    
    
    func menuButtonTapped() {
        router.menuButtonTapped()
    }
    
    
    func likeButtonTapped(cellWithIndex index: Int) {
        switch quoteCards.value[index].isFavorite {
        case false:
            quoteTask = Task {
                do {
                    var quoteCard = self.quoteCards.value[index]
                    quoteCard.isFavorite = true
                    try await self.quoteCardRepository.saveFavorite(quoteCard)
                    self.quoteCards.value[index].isFavorite = true
                } catch let domainError {
                    let sceneError = self.errorHandler.handle(domainError)
                    self.handle(sceneError)
                }
            }
        case true:
            quoteTask = Task {
                do {
                    var quoteCard = self.quoteCards.value[index]
                    quoteCard.isFavorite = false
                    try await self.quoteCardRepository.deleteFavorite(quoteCard)
                    self.quoteCards.value[index].isFavorite = false
                    //                    self.quoteCards.value = result
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
    
    private func setupObservers() {
        let state = quoteCardRepository.getState()
        state.quoteCards.subscribe(observer: self) { [weak self] cards in
            self?.quoteCards.value = cards
        }
    }
    
    private func handle(_ sceneError: MainSceneError_CN) {
        let errorMessage = sceneError.message
        error.value = errorMessage
        // there are no action cases yet
        guard let _ = sceneError.action else { return }
    }
    
}

