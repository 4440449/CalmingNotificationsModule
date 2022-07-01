//
//  InterfaceStyleManagement_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 11.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


// MARK: - Shadows

extension UIView {
    func setupShadows(color: UIColor? = nil,
                      offset: CGSize? = nil,
                      radius: CGFloat? = nil,
                      opacity: Float? = nil,
                      rasterize: Bool? = nil) {
        if let color = color?.cgColor { self.layer.shadowColor = color }
        if let offset = offset { self.layer.shadowOffset = offset }
        if let radius = radius { self.layer.shadowRadius = radius }
        if let opacity = opacity { self.layer.shadowOpacity = opacity }
        if let rasterize = rasterize {
            guard rasterize else {
                self.layer.shouldRasterize = false
                return
            }
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}

//struct ShadowSetup_CN {
//    var color: UIColor?
//    var offset: CGSize?
//    var radius: CGFloat?
//    var opacity: Float?
//    var rasterize: Bool?
//}
