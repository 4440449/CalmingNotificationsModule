//
//  NotificationGateway_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


protocol NotificationGateway_CN {
    func getAuthorizationStatus() async -> PushNotificationsAuthStatus_CN
    
    func fetch() async throws -> [Notification_CN]
    func addNew(at time: Date, quote: String) async throws -> [Notification_CN]
    // Cell interface
    func change(with identifier: String, new time: Date) async throws -> [Notification_CN]
    func remove(with identifire: String) async throws -> [Notification_CN]
    
}
