//
//  NotificationRepository_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


final class NotificationRepository_CN: NotificationGateway_CN {
    
    private let network: NotificationNetworkRepositoryProtocol_CN
    private let localStorage: NotificationPersistenceRepositoryProtocol_CN
    private let localPushNotificationsService: LocalPushNotificationsServiceProtocol_CN
    private let errorHandler: DomainErrorHandlerProtocol_CN
    
    init(network: NotificationNetworkRepositoryProtocol_CN,
         localStorage: NotificationPersistenceRepositoryProtocol_CN,
         localPushNotificatiosnService: LocalPushNotificationsServiceProtocol_CN,
         errorHandler: DomainErrorHandlerProtocol_CN) {
        self.network = network
        self.localStorage = localStorage
        self.localPushNotificationsService = localPushNotificatiosnService
        self.errorHandler = errorHandler
    }
    
    
    func getAuthorizationStatus() async -> PushNotificationsAuthStatus_CN {
        return await localPushNotificationsService.getAuthorizationStatus()
    }
    
    func fetch() async throws -> [Notification_CN] {
        //        sleep(2)
        let requests = await localPushNotificationsService.fetchNotifications()
        do {
            var domainEntities = try requests.map { try $0.parseToDomain() }
            domainEntities.sort { $0.time < $1.time }
            return domainEntities
        } catch let dataError {
            let domainError = errorHandler.handle(dataError)
            throw domainError
        }
    }
    
    func addNew(at time: Date, quote: String) async throws -> [Notification_CN] {
        do {
            try await localPushNotificationsService.addNewNotification(at: time, quote: quote)
            let result = try await fetch()
            return result
        } catch let dataError {
            let domainError = errorHandler.handle(dataError)
            throw domainError
        }
    }
    
    func change(with identifier: String, new time: Date) async throws -> [Notification_CN] {
        do {
            try await localPushNotificationsService.changeNotification(with: identifier, new: time)
            let result = try await fetch()
            return result
        } catch let dataError {
            let domainError = errorHandler.handle(dataError)
            throw domainError
        }
    }
    
    func remove(with identifire: String) async throws -> [Notification_CN] {
        do {
            try await localPushNotificationsService.removeNotification(with: identifire)
            let result = try await fetch()
            return result
        } catch let dataError {
            let domainError = errorHandler.handle(dataError)
            throw domainError
        }
    }
    
}
