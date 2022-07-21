//
//  CachedCollectionIndexPaths_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.07.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


extension UICollectionView {
    
    func cachedIndexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for s in 0..<self.numberOfSections {
            for i in 0..<numberOfItems(inSection: s) {
               let indexPath = IndexPath(item: i, section: s)
                   if let _ = cellForItem(at: indexPath) {
                       indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
}
