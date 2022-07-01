//
//  Animator_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 20.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


protocol CheckMarkAnimatableProtocol_CN {
    func checkMarkAnimation(for view: UIView)
}


final class Animator_CN: CheckMarkAnimatableProtocol_CN {
    
    // MARK: CheckMark
    // MARK: - Interface
    
    func checkMarkAnimation(for view: UIView) {
        feedbackGenerator.prepare()
        let checkMarkLayer = self.checkMarkLayer(for: view.bounds)
        let dimView = self.dimView(for: view.bounds)
        view.addSubview(dimView)
        view.layer.addSublayer(checkMarkLayer)
        self.dimAnimation(for: dimView)
        self.strokeCheckMarkAnimation(for: checkMarkLayer)
        feedbackGenerator.notificationOccurred(.success)
    }
    
    
    // MARK: Private -
    
    // MARK: - Feedback
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    
    // MARK: - Dim
    
    private func dimView(for frame: CGRect) -> UIView {
        let view = UIView()
        view.frame = frame
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }
    
    private func dimAnimation(for dimView: UIView) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseOut) { [weak dimView] in
            dimView?.alpha = 0.4
        } completion: { [weak dimView] _ in
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut) {
                dimView?.alpha = 0
            } completion: { _ in
                dimView?.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: - Check mark
    
    private func checkMarkLayer(for bounds: CGRect) -> CAShapeLayer {
        CATransaction.begin()
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX - 20,
                              y: bounds.midY - 20))
        path.addLine(to: CGPoint(x: bounds.midX,
                                 y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX + 25,
                                 y: bounds.midY - 50))
        layer.frame = bounds
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = nil
        layer.lineCap = .round
        layer.lineWidth = 5
        layer.lineJoin = .round
        return layer
    }

    private func strokeCheckMarkAnimation(for layer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath:"strokeEnd")
        pathAnimation.duration = 0.35
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.isRemovedOnCompletion = true
        CATransaction.setCompletionBlock { [weak self] in
            self?.hideCheckMarkAnimation(for: layer)
        }
        layer.add(pathAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    
    private func hideCheckMarkAnimation(for layer: CAShapeLayer) {
        let hideAnimation = CABasicAnimation(keyPath: "opacity")
        hideAnimation.duration = 0.2
        hideAnimation.fromValue = 1
        hideAnimation.toValue = 0
        hideAnimation.isRemovedOnCompletion = false
        hideAnimation.fillMode = .forwards
        CATransaction.setCompletionBlock { [weak layer] in
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
        }
        layer.add(hideAnimation, forKey: "opacity")
        CATransaction.commit()
    }
    
}
