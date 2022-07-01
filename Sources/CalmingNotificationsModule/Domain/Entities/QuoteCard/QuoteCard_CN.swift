//
//  QuoteCard_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 15.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


struct QuoteCard_CN {
    let quote: String
    let image: UIImage
    var id: UUID
    var isFavorite: Bool = false
}


extension QuoteCard_CN: Equatable {
    static func == (lhs: QuoteCard_CN, rhs: QuoteCard_CN) -> Bool {
        return lhs.id == rhs.id
    }
}
