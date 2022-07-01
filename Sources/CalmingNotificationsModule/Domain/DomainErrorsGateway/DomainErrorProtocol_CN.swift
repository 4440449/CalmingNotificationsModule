//
//  DomainErrorProtocol_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 25.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


protocol DomainError_CN: Error { }


protocol DomainErrorHandlerProtocol_CN {
    func handle(_ dataError: Error) -> DomainError_CN
}
