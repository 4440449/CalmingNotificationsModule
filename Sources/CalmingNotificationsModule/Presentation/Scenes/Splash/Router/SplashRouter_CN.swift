//
//  SplashRouter_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 04.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import UIKit


protocol SplashRouterProtocol_CN {
//    func startMainFlow(quoteCards: [QuoteCard_CN])
    func startMainFlow()
}


final class SplashRouter_CN: SplashRouterProtocol_CN {
    
    // MARK: - Dependencies
    
    private let repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN
    private weak var navigationContainer: UINavigationController?
    
    
    // MARK: - Init
    
    init(navigationContainer: UINavigationController,
         repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) {
        self.navigationContainer = navigationContainer
        self.repositoryDIContainer = repositoryDIContainer
    }
    
    
    // MARK: - Interface
    
    //    func startMainFlow(quoteCards: [QuoteCard_CN]) {
    func startMainFlow() {
        DispatchQueue.main.async {
//            let navigationContainer = UINavigationController()
//            let startVC = MainTabBarConfigurator_CN.configure(
//                quoteCards: quoteCards,
//                navigationContainer: navigationContainer,
//                repositoryDIContainer: self.repositoryDIContainer )
            guard let navigation = self.navigationContainer else { fatalError() }
            let startVC = MainSceneConfigurator_CN.configure(
                navigationContainer: navigation,
                repositoryDIContainer: self.repositoryDIContainer)
//            navigationContainer.pushViewController(startVC, animated: true)
            navigation.viewControllers = [startVC]
//            if let sceneDelegate =
//                UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//
//                sceneDelegate.window?.rootViewController = navigationContainer
//                sceneDelegate.window?.makeKeyAndVisible() // надо?
//            }
        }
    }
    
    deinit {
        //        print("SplashRouter_CN is deinit -------- ")
    }
    
}
