//
//  MainTabBarConfigurator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 10.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


final class MainTabBarConfigurator_CN {
    
    static func configure(
        quoteCards: [QuoteCard_CN],
        navigationContainer: UINavigationController,
        repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) -> UIViewController {
        let quotes = quoteCards.map { $0.quote }
        let view = MainTabBarViewController_CN()
        view.setupTabBarVC(quoteCards: quoteCards,
                           quotes: quotes,
                           navigationContainer: navigationContainer,
                           repositoryDIContainer: repositoryDIContainer)
        
        return view
    }
}
