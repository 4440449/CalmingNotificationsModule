//
//  SplashErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 24.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation



struct SplashSceneError_CN: SceneError_CN {
    enum SplashSceneErrorAction_CN {
        case tryToReloadData
    }
    
    let message: String
    var action: SplashSceneErrorAction_CN?
}


protocol SplashErrorHandlerProtocol_CN: SceneErrorHandlerProtocol_CN {
    func handle(_ domainError: Error) -> SplashSceneError_CN
}


final class SplashErrorHandler_CN: SplashErrorHandlerProtocol_CN {
    
    func handle(_ domainError: Error) -> SplashSceneError_CN {
        if let error = domainError as? QuoteCardError_CN {
            switch error {
            case .noInternetConnection:
                return SplashSceneError_CN(message: "Отсутствует интернет соединение, проверьте подключение и попробуйте еще раз",
                                           action: .tryToReloadData)
            case .networkError:
                return SplashSceneError_CN(message: "Ой, какая-то внешняя проблема, простите! Мы уже все чиним, попробуйте зайти позднее",
                                           action: nil)
            case .internalLogicError:
                // log action
                return SplashSceneError_CN(message: "Ой, какая-то внутренняя проблема, попробуйте зайти позднее",
                                           action: nil)
            case .localStorageError:
                return SplashSceneError_CN(message: "Ошибка хранилища, попробуйте переустановить приложение",
                                           action: nil)
            case .unknownError:
                return SplashSceneError_CN(message: "Неизвестная ошибка",
                                           action: nil)
            }
        } else {
            return SplashSceneError_CN(message: "Unknown error",
                                       action: nil)
        }
    }
    
}


