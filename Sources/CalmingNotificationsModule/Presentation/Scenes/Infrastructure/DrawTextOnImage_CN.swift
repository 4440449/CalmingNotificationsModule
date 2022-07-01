//
//  DrawTextOnImage.swift
//  CalmingNotifications
//
//  Created by Maxim on 14.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


extension UIImage {
    func drawTextOnImage(text: String,
                         textAttributes: [NSAttributedString.Key : Any],
                         textFrame: CGRect) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size,
                                               false,
                                               scale)
        let textFontAttributes = textAttributes
        self.draw(in: CGRect(origin: CGPoint.zero,
                              size: self.size))
        let rect = textFrame
        text.draw(in: rect,
                  withAttributes: textFontAttributes)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return newImage
    }
}



enum QuoteCardWallPaperDrawSetup_CN {
    
    struct Setup {
        let textAttributes: [NSAttributedString.Key : Any]
        let textFrame: CGRect
    }
    
    case standart
    
    func setup(for image: UIImage) -> Setup {
        switch self {
        case .standart:
            let textColor = UIColor.white
            let textFont = UIFont(name: "Montserrat-Regular", size: 18)!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let textAtr: [NSAttributedString.Key : Any] = [
                .font: textFont,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            let edgeOffset: CGFloat = 20
            let point = CGPoint(x: edgeOffset,
                                y: image.size.height / 2.5)
            let size = CGSize(width: image.size.width - (edgeOffset * 2),
                              height: image.size.height)
            let rect = CGRect(origin: point,
                              size: size)
            let setup = Setup(textAttributes: textAtr,
                              textFrame: rect)
            return setup
        }
    }
}
