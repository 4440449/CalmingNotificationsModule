//
//  FavoritesRouter_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


protocol FavoritesRouterProtocol_CN {
    func dismissButtonTapped()
    func shareButtonTapped(with content: UIImage, callback: @escaping (Bool) -> Void)
}


final class FavoritesRouter_CN: FavoritesRouterProtocol_CN {
    
    // MARK: - Dependencies
    
    private weak var view: UIViewController?
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
    
    func injectView(_ view: UIViewController) {
        self.view = view
    }
    
    
    // MARK: - Interface

    func dismissButtonTapped() {
        guard let view = view else { return }
        view.dismiss(animated: true, completion: nil)
    }
    
    func shareButtonTapped(with content: UIImage, callback: @escaping (Bool) -> Void) {
        let activityVC = UIActivityViewController(activityItems: [content],
                                                  applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            guard success else { callback(false); return }
            guard let activity = activity else { callback(false); return }
            switch activity {
            case .saveToCameraRoll:
                callback(true)
            default:
                if activity.rawValue == "com.apple.DocumentManagerUICore.SaveToFiles" {
                    callback(true)
                } else {
                    callback(false)
                }
            }
        }
        view?.present(activityVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Deinit

    deinit {
        //        print("deinit FavoritesRouter_CN")
    }
    
}
