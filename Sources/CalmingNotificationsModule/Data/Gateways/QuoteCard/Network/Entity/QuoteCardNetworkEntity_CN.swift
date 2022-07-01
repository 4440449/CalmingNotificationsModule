//
//  QuoteCardNetworkEntity_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 19.06.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import UIKit


// Error
enum QuoteCardNetworkEntityError_CN: Error {
    case parseToDomain(String)
    case parseFromDecoder(Error)
}



protocol DomainConvertable {
    associatedtype DomainEntity
    func parseToDomain() throws -> DomainEntity
}


struct QuoteCardNetworkEntity_CN: Decodable, DomainConvertable {
    let id: UUID
    let quote: String
    let imageData: String
    
    enum CodingKeys: CodingKey {
        case id
        case created_at
        case quote
        case image
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.quote = try container.decode(String.self, forKey: .quote)
            self.imageData = try container.decode(String.self, forKey: .image)
//            print(self.id)
//            print(self.quote)
//            print(self.imageData)
        } catch let error {
            throw QuoteCardNetworkEntityError_CN.parseFromDecoder(error)
        }
    }
    
    func parseToDomain() throws -> QuoteCard_CN {
        guard let imageData = Data(base64Encoded: self.imageData),
              let image = UIImage(data: imageData),
              let scaleImage = image.scale(toSize: CGSize(width: UIScreen.main.bounds.width,
                                                          height: UIScreen.main.bounds.height)) else {
                  throw QuoteCardNetworkEntityError_CN.parseToDomain("Error image convert")
              }
        return .init(quote: self.quote,
                     image: scaleImage,
                     id: self.id)
    }
}
