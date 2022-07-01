//
//  MainTabBarViewController_CN.swift
//  CalmingNotifications
//
//  Created by Max on 12.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


final class MainTabBarViewController_CN: UITabBarController {
    
    // MARK: - View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
    }
    
    
    // MARK: - Setup VC
    
    func setupTabBarVC(quoteCards: [QuoteCard_CN],
                       quotes: [String],
                       navigationContainer: UINavigationController,
                       repositoryDIContainer: GatewaysRepositoryDIContainerProtocol_CN) {
    }
    
    
    // MARK: - UI -
    
    private func setupTabBarUI() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }
    
}
