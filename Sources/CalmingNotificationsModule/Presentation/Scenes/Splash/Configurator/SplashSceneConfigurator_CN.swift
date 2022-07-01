//
//  SplashSceneConfigurator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 04.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


public final class SplashSceneConfigurator_CN: SceneConfiguratorProtocol_CN {
    
    public static func configure() -> UIViewController {
        let navigationContainer = UINavigationController()
        navigationContainer.navigationBar.isHidden = true
        let repositoryDIContainer = GatewaysRepositoryDIContainer_CN()
        let repository = repositoryDIContainer.quoteCard
        let router = SplashRouter_CN(navigationContainer: navigationContainer,
                                     repositoryDIContainer: repositoryDIContainer)
        let errorHandler = SplashErrorHandler_CN()
        let viewModel = SplashViewModel_CN(quoteCardRepository: repository,
                                           errorHandler: errorHandler,
                                           router: router)
        let splashView = SplashViewController_CN(viewModel: viewModel,
                                                 nibName: nil,
                                                 bundle: nil)
        navigationContainer.viewControllers = [splashView]
        return navigationContainer
    }
    
    deinit {
        //        print("SplashSceneConfigurator_CN is deinit -------- ")
    }
    
}
