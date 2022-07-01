//
//  NotificationsErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 24.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import BabyNet


final class NotificationsErrorHandler_CN: DomainErrorHandlerProtocol_CN {
    
    func handle(_ dataError: Error) -> DomainError_CN {
        print(" *+*- \(dataError) *+*-")
        if let _ = dataError as? LocalPushNotificationCenterError {
            return NotificationError_CN.nativeServiceError
        } else {
            return NotificationError_CN.unknownError
        }
    }
}

