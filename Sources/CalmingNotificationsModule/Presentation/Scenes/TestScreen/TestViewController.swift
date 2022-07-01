//
//  TestViewController.swift
//  CalmingNotifications
//
//  Created by Maxim on 19.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)

        btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 128).isActive = true
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        btn.setTitle("Tap here!", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc func tapped() {
        i += 1
        print("Running \(i)")

        switch i {
        case 1:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case 2:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case 3:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

        case 4:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case 5:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case 6:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            i = 0
        }
    }
}


//final class TestCollectionView: UICollectionView {
    
//    override func layoutIfNeeded() {
//        UIView.animate(withDuration: 0.5) {
//            super.layoutIfNeeded()
//        }
//    }
//
//    override func layoutSubviews() {
//        UIView.transition(with: self,
//                          duration: 0.3,
//                          options: [.transitionCrossDissolve],
//                          animations: {
//            super.layoutSubviews()
//        })
//    }
    
//    override func setNeedsLayout() {
//        UIView.animate(withDuration: 0.5) {
//            super.setNeedsLayout()
//        }
//    }
    
//}
