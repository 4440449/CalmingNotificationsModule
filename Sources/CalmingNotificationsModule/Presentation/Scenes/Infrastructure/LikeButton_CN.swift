//
//  LikeButton_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.07.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


class LikeButton_CN: UIButton {
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0,
                                   options: .curveEaseIn,
                                   animations: {
                        self.transform = CGAffineTransform(scaleX: 1.9,
                                                           y: 1.9)
                    }) { _ in
                        UIView.animate(withDuration: 0.2,
                                       delay: 0,
                                       usingSpringWithDamping: 1,
                                       initialSpringVelocity: 0,
                                       options: .curveEaseIn,
                                       animations: {
                            self.transform = CGAffineTransform(scaleX: 1.0,
                                                               y: 1.0)
                        }, completion: nil)
                    }
                }
            case false:
                break
            }
        }
    }
}
