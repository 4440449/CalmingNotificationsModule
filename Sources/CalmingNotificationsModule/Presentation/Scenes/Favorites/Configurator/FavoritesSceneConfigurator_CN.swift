//
//  FavoritesSceneConfigurator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


final class FavoritesSceneConfigurator_CN: SceneConfiguratorProtocol_CN {
    
    static func configure(navigationContainer: UINavigationController, repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) -> UIViewController {
        let repo = repositoryDIContainer.quoteCard
        let errorHandler = FavoritesErrorHandler_CN()
        let router = FavoritesRouter_CN(navigationContainer: navigationContainer,
                                        repositoryDIContainer: repositoryDIContainer)
        let viewModel = FavoritesViewModel_CN(router: router,
                                              quoteCardRepository: repo,
                                              errorHandler: errorHandler)
        let view = FavoritesViewController_CN(viewModel: viewModel,
                                              nibName: nil,
                                              bundle: nil)
        router.injectView(view)
        return view
    }
    
    deinit {
//        print("deinit FavoritesSceneConfigurator_CN")
    }
}
