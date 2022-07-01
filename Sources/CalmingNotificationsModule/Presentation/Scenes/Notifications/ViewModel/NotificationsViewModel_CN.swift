//
//  NotificationsViewModel_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import MommysEye
import CloudKit


protocol NotificationsViewModelProtocol_CN {
    // MARK: Input
    func viewDidLoad()
    func sceneWillEnterForeground()
    func example() -> ((Int) -> ())
    // MARK: Output
    var notifications: Publisher<[Notification_CN]> { get }
    var pushNotificationAuthStatus: Publisher<PushNotificationsAuthStatus_CN> { get }
    var isLoading: Publisher<Loading_CN> { get }
    var error: Publisher<String> { get }
}

protocol NotificationsHeaderViewModelProtocol_CN {
    // MARK: Input
    func addNewNotificationButtonTapped(date: Date)
    func dismissButtonTapped()
}

protocol NotificationsCellViewModelProtocol_CN {
    // MARK: Input
    func saveButtonTapped(cellWithIndex index: Int, new time: Date)
    func deleteButtonTapped(cellWithIndex index: Int)
}



final class NotificationsViewModel_CN: NotificationsViewModelProtocol_CN,
                                       NotificationsHeaderViewModelProtocol_CN,
                                       NotificationsCellViewModelProtocol_CN {
    func example() -> ((Int) -> ()) {
        return { number in
            print(number)
        }
    }
    
    
    // MARK: - Dependencies
    
    private let repository: NotificationGateway_CN
    private let router: NotificationsRouterProtocol_CN
    private let errorHandler: NotificationsSceneErrorHandlerProtocol_CN
    
    init(repository: NotificationGateway_CN,
         router: NotificationsRouterProtocol_CN,
         errorHandler: NotificationsSceneErrorHandlerProtocol_CN,
         quotes: [String]) {
        self.repository = repository
        self.router = router
        self.errorHandler = errorHandler
        self.quotes = quotes
    }
    
    // MARK: - State / Observable
    
    var notifications = Publisher(value: [Notification_CN]())
    var pushNotificationAuthStatus = Publisher(value: PushNotificationsAuthStatus_CN.authorized)
    var isLoading = Publisher(value: Loading_CN.false)
    var error = Publisher(value: "")
    
    
    // MARK: - Private state / Task
    
    private var task: Task<(), Never>? { willSet { self.task?.cancel() } }
    private var quotes = [String]()
    
    
    // MARK: - Collection interface
    
    func viewDidLoad() {
        loadData()
    }
    
    func sceneWillEnterForeground() {
        loadData()
    }
    
    
    // MARK: - Header interface
    
    func addNewNotificationButtonTapped(date: Date) {
        guard let time = date.hh_mm(),
              !notifications.value.contains(where: { $0.time == time }) else {
                  return
              }
        isLoading.value = .true
        task = Task(priority: nil) {
            do {
                guard let rndmQuote = self.quotes.randomElement() else { return }
                let result = try await self.repository.addNew(at: date, quote: rndmQuote)
                self.notifications.value = result
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
            self.isLoading.value = .false
        }
    }
    
    func dismissButtonTapped() {
        router.dismissButtonTapped()
    }
    
    
    // MARK: - Cell interface
    
    func saveButtonTapped(cellWithIndex index: Int, new date: Date) {
        guard let time = date.hh_mm() else { return }
        guard notifications.value[index].time != time else { return }
        isLoading.value = .true
        task = Task(priority: nil) {
            do {
                let result = try await self.repository.change(with: notifications.value[index].id, new: date)
                self.notifications.value = result
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
            self.isLoading.value = .false
        }
    }
    
    func deleteButtonTapped(cellWithIndex index: Int) {
        isLoading.value = .true
        task = Task(priority: nil) {
            do {
                let result = try await repository.remove(with: self.notifications.value[index].id)
                self.notifications.value = result
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
            self.isLoading.value = .false
        }
    }
    
    
    // MARK: - Private
    
    private func loadData() {
        isLoading.value = .true
        task = Task(priority: nil) {
            let authStatus = await self.repository.getAuthorizationStatus()
            guard authStatus == .authorized else {
                self.notifications.value = []
                self.pushNotificationAuthStatus.value = authStatus
                self.isLoading.value = .false
                return
            }
            self.pushNotificationAuthStatus.value = authStatus
            do {
                let result = try await self.repository.fetch()
                self.notifications.value = result
            } catch let domainError {
                let sceneError = self.errorHandler.handle(domainError)
                self.handle(sceneError)
            }
            let result = await self.repository.getAuthorizationStatus()
            self.pushNotificationAuthStatus.value = result
            self.isLoading.value = .false
        }
    }
    
    private func handle(_ sceneError: NotificationsSceneError_CN) {
        let errorMessage = sceneError.message
        error.value = errorMessage
        // there are no action cases yet
        guard let _ = sceneError.action else { return }
    }
    
    deinit {
        //        print("deinit NotificationsViewModel_CN")
    }
}
