//
//  NotificationSceneConfigurator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


final class NotificationSceneConfigurator_CN: SceneConfiguratorProtocol_CN {
    
    static func configure(navigationContainer: UINavigationController,
                          repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) -> UIViewController {
//                          ,
//                          quotes: [String]) -> UIViewController {
        // Сделать интерфейс у нотификейшн сущности, чтобы сама запрашивала цитаты?
        // По сути пока заглушка, т.к. все равно нужны только ремот нотификации с бэка
        let quotes = repositoryDIContainer.quoteCard.getState().quotes.value

        let repo = repositoryDIContainer.notification
        let router = NotificationsRouter_CN(
            navigationContainer: navigationContainer,
            repositoryDIContainer: repositoryDIContainer )
        let errorHandler = NotificationsSceneErrorHandler_CN()
        let viewModel = NotificationsViewModel_CN(repository: repo,
                                                  router: router,
                                                  errorHandler: errorHandler,
                                                  quotes: quotes)
        let view = NotificationsViewController_CN(viewModel: viewModel,
                                                  nibName: nil,
                                                  bundle: nil)
        router.injectView(view)
        return view
    }
}
