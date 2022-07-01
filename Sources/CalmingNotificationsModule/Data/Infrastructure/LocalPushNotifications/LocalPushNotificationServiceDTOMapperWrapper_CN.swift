//
//  LocalPushNotificationServiceDTOMapperWrapper_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 24.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import UserNotifications


protocol LocalPushNotificationsDTOMapperProtocol_CN {
    func convert(notificationRequest: [UNNotificationRequest]) throws -> [Notification_CN]
}


final class LocalPushNotificationsDTOMapper_CN: LocalPushNotificationsDTOMapperProtocol_CN {

    func convert(notificationRequest: [UNNotificationRequest]) throws -> [Notification_CN] {
        var domainEntities = [Notification_CN]()
        try notificationRequest.forEach { let domain = try $0.parseToDomain()
//            let domain = try Notification_CN(notificationRequest: $0)
            domainEntities.append(domain)
        }
        return domainEntities
    }
}
