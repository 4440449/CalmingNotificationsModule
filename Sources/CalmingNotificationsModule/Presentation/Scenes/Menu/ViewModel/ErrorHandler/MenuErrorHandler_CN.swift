//
//  MenuErrorHandler_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 11.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


// TODO: - FIX THE ERROR HANDLER !

protocol MenuErrorHandlerProtocol_CN: SceneErrorHandlerProtocol_CN { }


final class MenuErrorHandler_CN: MenuErrorHandlerProtocol_CN {

    func handle(_ error: Error) -> String {
        print("error notif --> \(error)")
        return ""
    }
}
