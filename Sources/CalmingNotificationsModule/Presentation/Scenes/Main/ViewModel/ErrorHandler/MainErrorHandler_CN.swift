//
//  MainErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 14.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


struct MainSceneError_CN: SceneError_CN {
    enum MainSceneErrorrAction_CN { }
    
    let message: String
    var action: MainSceneErrorrAction_CN?
}


protocol MainErrorHandlerProtocol_CN: SceneErrorHandlerProtocol_CN {
    func handle(_ domainError: Error) -> MainSceneError_CN
}


final class MainErrorHandler_CN: MainErrorHandlerProtocol_CN {
    
    func handle(_ domainError: Error) -> MainSceneError_CN {
        if let error = domainError as? QuoteCardError_CN {
            switch error {
            case .noInternetConnection:
                return MainSceneError_CN(message: "Отсутствует интернет соединение, проверьте подключение и попробуйте еще раз",
                                         action: nil)
            case .networkError:
                return MainSceneError_CN(message: "Ой, какая-то внешняя проблема, простите! Мы уже все чиним, попробуйте зайти позднее",
                                         action: nil)
            case .internalLogicError:
                return MainSceneError_CN(message: "Ой, какая-то внутренняя проблема, пожалуйста отправьте отчет разработчикам",
                                         action: nil)
            case .localStorageError:
                return MainSceneError_CN(message: "Ошибка хранилища, попробуйте переустановить приложение",
                                         action: nil)
            case .unknownError:
                return MainSceneError_CN(message: "Неизвестная ошибка",
                                         action: nil)
            }
        } else {
            return MainSceneError_CN(message: "Unknown error",
                                     action: nil)
        }
    }
}
