//
//  MenuRouter_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


protocol MenuRouterProtocol_CN {
    func didSelect(menuItem: MenuItem)
}


final class MenuRouter_CN: MenuRouterProtocol_CN {
    
    // MARK: - Dependencies
    
    weak var view: UIViewController?
    private unowned var navigationContainer: UINavigationController
    private let repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN
    
    
    // MARK: - Init
    
    init(view: UIViewController? = nil,
         navigationContainer: UINavigationController,
         repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) {
        self.view = view
        self.navigationContainer = navigationContainer
        self.repositoryDIContainer = repositoryDIContainer
    }
    
    
    // MARK: - Interface
    
    func didSelect(menuItem: MenuItem) {
        guard let view = view else { return }
        view.dismiss(animated: true, completion: nil)
        switch menuItem.item {
        case .favorites:
            let favoritesVC = FavoritesSceneConfigurator_CN.configure(
                navigationContainer: navigationContainer,
                repositoryDIContainer: repositoryDIContainer )
            favoritesVC.modalPresentationStyle = .fullScreen
            navigationContainer.present(favoritesVC, animated: true, completion: nil)
        case .notifications:
            let notificationsVC = NotificationSceneConfigurator_CN.configure(
                navigationContainer: navigationContainer,
                repositoryDIContainer: repositoryDIContainer)
            notificationsVC.modalPresentationStyle = .fullScreen
            navigationContainer.present(notificationsVC, animated: true, completion: nil)
        }
    }
    
}
