//
//  QuoteCardErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 24.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import BabyNet


final class QuoteCardErrorHandler_CN: DomainErrorHandlerProtocol_CN {
    
    func handle(_ dataError: Error) -> DomainError_CN {
        print(" *+*- \(dataError) *+*-")
        if let domainError = dataError as? BabyNetError {
            switch domainError {
            case .badRequest(let err):
                if let err = err as? URLError, (err.code == .notConnectedToInternet || err.code == .dataNotAllowed) {
                    return QuoteCardError_CN.noInternetConnection
                } else {
                    return QuoteCardError_CN.networkError
                }
            default:
                return QuoteCardError_CN.networkError
            }
        } else if let _ = dataError as? QuoteCardNetworkEntityError_CN {
            return QuoteCardError_CN.internalLogicError
        } else if let _ = dataError as? QuoteCardLocalStorageError {
            return QuoteCardError_CN.localStorageError
        } else {
            return QuoteCardError_CN.unknownError
        }
    }
}
