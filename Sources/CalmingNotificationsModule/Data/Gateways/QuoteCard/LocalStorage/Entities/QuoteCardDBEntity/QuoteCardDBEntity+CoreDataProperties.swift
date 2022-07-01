//
//  QuoteCardDBEntity+CoreDataProperties.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension QuoteCardDBEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuoteCardDBEntity> {
        return NSFetchRequest<QuoteCardDBEntity>(entityName: "QuoteCardDBEntity")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var quote: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var date: Date?
    
}

extension QuoteCardDBEntity : Identifiable {
    
}

extension QuoteCardDBEntity {
    
    func parseToDBEntity(domain: QuoteCard_CN) throws {
        guard let jpegData = domain.image.jpegData(compressionQuality: 1) else {
            throw QuoteCardLocalStorageError.failureToDBEntityMapping("Failure PNG representation data --> \(domain.image)")
        }
        image = jpegData
        quote = domain.quote
        id = domain.id
        isFavorite = domain.isFavorite
        date = Date()
    }
    
    func parseToDomainEntity() throws -> QuoteCard_CN  {
        guard let data = self.image,
              let image = UIImage(data: data),
              let scaleImage = image.scale(toSize: CGSize(width: UIScreen.main.bounds.width,
                                                          height: UIScreen.main.bounds.height)),
              let quote = self.quote,
              let id = self.id else {
                  throw QuoteCardLocalStorageError.failureToDomainEntityMapping("Invalid entity data --> \(self.debugDescription)")
              }
        return .init(quote: quote,
                     image: scaleImage,
                     id: id,
                     isFavorite: self.isFavorite)
    }
    
}


extension UIImage {
    func scale(toSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: toSize))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
}
