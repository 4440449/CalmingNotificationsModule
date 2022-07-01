//
//  FavoritesErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


struct FavoritesSceneError_CN: SceneError_CN {
    enum FavoritesSceneErrorrAction_CN { }
    
    let message: String
    var action: FavoritesSceneErrorrAction_CN?
}

protocol FavoritesErrorHandlerProtocol_CN: SceneErrorHandlerProtocol_CN {
    func handle(_ domainError: Error) -> FavoritesSceneError_CN
}


final class FavoritesErrorHandler_CN: FavoritesErrorHandlerProtocol_CN {
    
    func handle(_ domainError: Error) -> FavoritesSceneError_CN {
        if let error = domainError as? QuoteCardError_CN {
            switch error {
            case .noInternetConnection:
                return FavoritesSceneError_CN(message: "Отсутствует интернет соединение, проверьте подключение и попробуйте еще раз",
                                              action: nil)
            case .networkError:
                return FavoritesSceneError_CN(message: "Ой, какая-то внешняя проблема, простите! Мы уже все чиним, попробуйте зайти позднее",
                                              action: nil)
            case .internalLogicError:
                return FavoritesSceneError_CN(message: "Ой, какая-то внутренняя проблема, пожалуйста отправьте отчет разработчикам",
                                              action: nil)
            case .localStorageError:
                return FavoritesSceneError_CN(message: "Ошибка хранилища, попробуйте переустановить приложение",
                                              action: nil)
            case .unknownError:
                return FavoritesSceneError_CN(message: "Неизвестная ошибка",
                                              action: nil)
            }
        } else {
            return FavoritesSceneError_CN(message: "Unknown error",
                                          action: nil)
            
        }
    }
}
