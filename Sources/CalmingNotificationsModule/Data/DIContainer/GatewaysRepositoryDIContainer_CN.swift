//
//  GatewaysRepositoryDIContainer_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 09.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import BabyNet


protocol GatewaysRepositoryDIContainerProtocol_CN {
    var quoteCard: QuoteCardGateway_CN { get }
    var notification: NotificationGateway_CN { get }
    var menuItem: MenuItemGateway_CN { get }
}


final class GatewaysRepositoryDIContainer_CN: GatewaysRepositoryDIContainerProtocol_CN {
    
    // MARK: - Dependencies
    let quoteCard: QuoteCardGateway_CN
    let notification: NotificationGateway_CN
    let menuItem: MenuItemGateway_CN
    
    
    // MARK: - Init / External injection
    init(quoteCard: QuoteCardGateway_CN = createQuoteCardRepository(),
         notification: NotificationGateway_CN = createNotificationRepository(),
         menuItem: MenuItemGateway_CN = createMenuItemRepository()) {
        self.quoteCard = quoteCard
        self.notification = notification
        self.menuItem = menuItem
    }
    
    
    // MARK: - Default internal injection
    static func createQuoteCardRepository() -> QuoteCardGateway_CN {
        let client = BabyNetRepository()
        let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNydXZtZ3V1YWRyaWt4amdscml3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ3ODgyMzgsImV4cCI6MTk3MDM2NDIzOH0.udc8nAU84lOWCgJChCCq815w0oBoXh6zrceObzg8Z1Q"
        let network = QuoteCardNetworkRepository(client: client,
                                                 apiKey: apiKey,
                                                 sessionDelegate: nil)
        let localStorage = QuoteCardPersistenceRepository()
        let errorHandler = QuoteCardErrorHandler_CN()
        let repo = QuoteCardRepository_CN(network: network,
                                          localStorage: localStorage,
                                          errorHandler: errorHandler,
                                          quoteCardState: QuoteCardState_CN())
        return repo
    }
    
    static func createNotificationRepository() -> NotificationGateway_CN {
        let network = NotificationNetworkRepository_CN()
        let localStorage = NotificationPersistenceRepository_CN()
        let localPushNotificationService = LocalPushNotificationsService_CN()
        let errorHandler = NotificationsErrorHandler_CN()
        let repo = NotificationRepository_CN(network: network,
                                             localStorage: localStorage,
                                             localPushNotificatiosnService: localPushNotificationService,
                                             errorHandler: errorHandler)
        return repo
    }
    
    static func createMenuItemRepository() -> MenuItemGateway_CN {
        let repo = MenuItemRepository_CN()
        return repo
    }
    
}
