//
//  NotificationsRouter_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

protocol NotificationsRouterProtocol_CN {
    func dismissButtonTapped()
}


final class NotificationsRouter_CN: NotificationsRouterProtocol_CN {
    
    // MARK: - Dependencies
    
    private weak var view: UIViewController?
    private unowned var navigationContainer: UINavigationController
    private let repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN
    
    
    // MARK: - Init
    
    init(navigationContainer: UINavigationController,
         repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) {
        self.navigationContainer = navigationContainer
        self.repositoryDIContainer = repositoryDIContainer
    }
    
    func injectView(_ view: UIViewController) {
        self.view = view
    }
    
    
    // MARK: - Interface
    
    func dismissButtonTapped() {
        guard let view = view else { return }
        view.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Deinit
    
    deinit {
        //        print("deinit NotificationsRouter_CN")
    }
    
}
