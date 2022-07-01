//
//  MenuItem_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 11.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


//struct MenuItem {
//
//    enum Title: String {
//        case favorites = "Favorites"
//        case notifications = "Notifications"
//    }
//
//    let title: Title
//}


struct MenuItem {
    
    enum Item {
        case favorites
        case notifications
        
        func get() -> (String, UIImage) {
            switch self {
            case .favorites:
                return ("Избранное", UIImage(systemName: "heart.fill")!)
            case .notifications:
                return ("Уведомления", UIImage(systemName: "bell.fill")!)
            }
        }
    }
    
    let item: Item
}
