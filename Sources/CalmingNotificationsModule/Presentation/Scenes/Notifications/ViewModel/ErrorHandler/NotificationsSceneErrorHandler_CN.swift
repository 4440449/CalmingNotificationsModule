//
//  NotificationsErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 24.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation



struct NotificationsSceneError_CN: SceneError_CN {
    enum NotificationsSceneErrorAction_CN { }
    
    let message: String
    var action: NotificationsSceneErrorAction_CN?
}


protocol NotificationsSceneErrorHandlerProtocol_CN: SceneErrorHandlerProtocol_CN {
    func handle(_ domainError: Error) -> NotificationsSceneError_CN
}


final class NotificationsSceneErrorHandler_CN: NotificationsSceneErrorHandlerProtocol_CN {
    
    func handle(_ domainError: Error) -> NotificationsSceneError_CN {
        if let error = domainError as? NotificationError_CN {
            switch error {
            case .nativeServiceError:
                return NotificationsSceneError_CN(message: "Ой, какая-то внутренняя проблема, пожалуйста отправьте нам отчет",
                                                  action: nil)
            case . unknownError:
                return NotificationsSceneError_CN(message: "Неизвестная ошибка",
                                                  action: nil)
            }
        } else {
            return NotificationsSceneError_CN(message: "Unknown error",
                                              action: nil)
        }
    }
    
}
