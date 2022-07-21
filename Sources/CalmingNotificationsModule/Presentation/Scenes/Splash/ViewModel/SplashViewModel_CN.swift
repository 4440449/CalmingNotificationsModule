//
//  SplashViewModel_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 04.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import MommysEye


protocol SplashViewModelProtocol_CN {
    var isLoading: Publisher<Loading_CN> { get }
    var progress: Publisher<Float> { get }
    var isHiddenProgressBar: Publisher<Bool> { get }
    var isHiddenReloadButton: Publisher<Bool> { get }
    var isHiddenCloseButton: Publisher<Bool> { get }
    var error: Publisher<String> { get }
    func reloadButtonTapped()
    func closeAlert()
}


final class SplashViewModel_CN: SplashViewModelProtocol_CN {
    
    // MARK: - Dependencies
    
    private let quoteCardRepository: QuoteCardGateway_CN
    private let errorHandler: SplashErrorHandlerProtocol_CN
    private let router: SplashRouterProtocol_CN
    
    
    // MARK: - Init
    
    init(quoteCardRepository: QuoteCardGateway_CN,
         errorHandler: SplashErrorHandlerProtocol_CN,
         router: SplashRouterProtocol_CN) {
        self.quoteCardRepository = quoteCardRepository
        self.errorHandler = errorHandler
        self.router = router
    }
    
    
    // MARK: - State
    
    var isLoading = Publisher(value: Loading_CN.false)
    var progress = Publisher(value: Float(0))
    var isHiddenProgressBar = Publisher(value: false)
    var isHiddenReloadButton = Publisher(value: true)
    var isHiddenCloseButton = Publisher(value: true)
    var error = Publisher(value: "")
    
    
    // MARK: - Private state
    
    private var quoteTask: Task<Void, Error>?
    
    
    // MARK: - Interface
    
    func reloadButtonTapped() {
        isHiddenProgressBar.value = false
        isHiddenReloadButton.value = true
        isHiddenCloseButton.value = true
        quoteTask = Task {
            do {
                try await quoteCardRepository.setState(taskProgressCallback: { [weak self] progress in
                    self?.progress.value = Float(progress.fractionCompleted)
                })
                self.quotesLoaded()
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
        }
    }
    
    func closeAlert() {
        error.value = ""
    }
    
    
    // MARK: - Private
    
    private func handle(_ sceneError: SplashSceneError_CN) {
        let errorMessage = sceneError.message
        error.value = errorMessage
        guard let action = sceneError.action else { return }
        switch action {
        case .tryToReloadData:
            isHiddenProgressBar.value = true
            isHiddenReloadButton.value = false
            isHiddenCloseButton.value = false
        }
    }
    
    private func quotesLoaded() {
        router.startMainFlow()
    }
    
    deinit {
        //        print("SplashViewModel_CN is deinit -------- ")
    }
    
}
