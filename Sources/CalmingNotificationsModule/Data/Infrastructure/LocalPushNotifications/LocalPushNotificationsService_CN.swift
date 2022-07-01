//
//  NotificationService_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 18.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UserNotifications
import Foundation


protocol LocalPushNotificationsServiceProtocol_CN {
    func fetchNotifications() async -> [UNNotificationRequest]
    func addNewNotification(at time: Date, quote: String) async throws
    func changeNotification(with identifier: String, new time: Date) async throws
    func removeNotification(with identifier: String) async throws
    func getAuthorizationStatus() async -> PushNotificationsAuthStatus_CN
}


final class LocalPushNotificationsService_CN: LocalPushNotificationsServiceProtocol_CN {
    
    
    // MARK: - Dependencies

    private let center = UNUserNotificationCenter.current()
    
    
    // MARK: - Interface

    func fetchNotifications() async -> [UNNotificationRequest] {
        let result = await center.pendingNotificationRequests()
        return result
    }
    
    
    func addNewNotification(at time: Date, quote: String) async throws {
        let content = UNMutableNotificationContent()
        content.body = quote
        content.sound = .default
//            cont.title = "Moms' Exhale"
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: true)
        let request = UNNotificationRequest(identifier: String(describing: components),
                                            content: content,
                                            trigger: trigger)
        try await center.add(request)
    }
    
  
    func removeNotification(with identifier: String) async throws {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        let result = await fetchNotifications()
        try result.forEach {
            if $0.identifier == identifier {
                throw LocalPushNotificationCenterError.failureRemoving("Removing notification error! Request with identifier --> \(identifier) not deleted")
            } else {
                return
            }
        }
    }
    
    
    func changeNotification(with identifier: String, new time: Date) async throws {
        let notifications = await center.pendingNotificationRequests()
        let notification = notifications.filter { $0.identifier == identifier }
        guard let quote = notification.first?.content.body else {
            throw LocalPushNotificationCenterError.failureFetching("Request with identifier --> '\(identifier)' not found ::: Fetched identifiers == \(notifications.map { $0.identifier })")
        }
        try await removeNotification(with: identifier)
        try await addNewNotification(at: time, quote: quote)
    }
    
    
    func getAuthorizationStatus() async -> PushNotificationsAuthStatus_CN {
        return await withCheckedContinuation { continuation in
            var status = PushNotificationsAuthStatus_CN.notAuthorized
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized,
                   (settings.alertSetting == .enabled || settings.lockScreenSetting == .enabled || settings.notificationCenterSetting == .enabled) {
                    status = .authorized
                } else {
                    status = .notAuthorized
                }
                continuation.resume(returning: status)
            }
        }
    }
    
}


// MARK: - Parse to domain entity extension

extension UNNotificationRequest {
    func parseToDomain() throws -> Notification_CN {
        guard let trigger = self.trigger as? UNCalendarNotificationTrigger,
              let hour = trigger.dateComponents.hour,
              let minute = trigger.dateComponents.minute,
              let time = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) else {
                  throw LocalPushNotificationCenterError.failureMapping("Invalid UNNotificationRequest.trigger --> \(self.trigger.debugDescription)")
              }
        return .init(id: self.identifier, time: time)
    }
}


// MARK: - Errors

enum LocalPushNotificationCenterError: Error {
    case failureRemoving(String)
    case failureMapping(String)
    case failureFetching(String)
}



//"Закрой глаза.. Глубойкий вдох - выдох.. Ты съела все мороженое. Остановись.."


//print("alertSetting == \(settings.alertSetting.rawValue)")
//print("lockScreenSetting == \(settings.lockScreenSetting.rawValue)")
//print("notificationCenterSetting == \(settings.notificationCenterSetting.rawValue)")
//
//print("badgeSetting == \(settings.badgeSetting.rawValue)") // налкейки
//print("soundSetting == \(settings.soundSetting.rawValue)") // звук
