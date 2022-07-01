//
//  MainSceneConfigurator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


final class MainSceneConfigurator_CN: SceneConfiguratorProtocol_CN {
    
    static func configure(navigationContainer: UINavigationController,
                          repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) -> UIViewController {
        let repo = repositoryDIContainer.quoteCard
        let router = MainRouter_CN(navigationContainer: navigationContainer,
                                   repositoryDIContainer: repositoryDIContainer)
        let errorHandler = MainErrorHandler_CN()
        let viewModel = MainViewModel_CN(quoteCardRepository: repo,
                                         router: router,
                                         errorHandler: errorHandler)
        let animator = Animator_CN()
        let view = MainViewController_CN(viewModel: viewModel,
                                         animator: animator,
                                         nibName: nil,
                                         bundle: nil)
        return view
    }
}
