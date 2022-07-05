//
//  MenuTransitionDelegate_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 04.07.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


// MARK: - Delegate

final class MenuTransitionDelegate_CN: NSObject, UIViewControllerTransitioningDelegate {
    
    private let interactiveTransition = MenuInteractiveTransitionDriver_CN()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        interactiveTransition.setDependencies(presentedVC: presented)
        return MenuDimmViewController_CN(presentedViewController: presented,
                                         presenting: presenting ?? source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuPresentAnimator_CN()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuDismissAnimator_CN()
    }
    //
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    
}


// MARK: - UIPresentationController

final class MenuDimmViewController_CN: UIPresentationController {
    
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0,
                                       alpha: 0.3)
        view.alpha = 0
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(didTap))
    private lazy var panGesture = UIPanGestureRecognizer(target: self,
                                                         action: #selector(didPan))
    
    @objc private func didTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            presentedViewController.dismiss(animated: true, completion: nil)
        default: return
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let presentedViewSize = CGSize(width: container.bounds.width,
                                       height: container.bounds.height / 2.5)
        let presentedViewOrigin = CGPoint(x: container.bounds.minX,
                                          y: container.bounds.height - presentedViewSize.height)
        let rect = CGRect(origin: presentedViewOrigin,
                          size: presentedViewSize)
        return rect
    }
    
    // MARK: Presentation
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView,
              let presentedView = presentedView
        else { return }
        dimmView.frame = containerView.frame
        presentedView.frame = frameOfPresentedViewInContainerView
        containerView.addSubview(dimmView)
        containerView.addSubview(presentedView)
        UIView.animate(withDuration: 0.3) {
            self.dimmView.alpha = 1
        }
    }
    
    // MARK: Dismiss
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: { context in
            UIView.animate(withDuration: 0.3) {
                self.dimmView.alpha = 0
            }
        }, completion: nil)
    }
    
}


//MARK: - Interactive transition

final class MenuInteractiveTransitionDriver_CN: UIPercentDrivenInteractiveTransition {
    
    private weak var presentedVC: UIViewController?
    private var panGesture: UIPanGestureRecognizer?
    
    override var wantsInteractiveStart: Bool {
        get { return gestureIsBegan }
        set { }
    }
    
    private var gestureIsBegan = false
    
    func setDependencies(presentedVC: UIViewController) {
        panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(handleDismiss(recognizer:)) )
        presentedVC.view.addGestureRecognizer(panGesture!)
        self.presentedVC = presentedVC
    }
    
    
    @objc private func handleDismiss(recognizer: UIPanGestureRecognizer) {
        guard let presentedVC = presentedVC else { return }
        let translation = recognizer.translation(in: presentedVC.view.superview).y * 1.05
        recognizer.setTranslation(.zero, in: presentedVC.view.superview)
        let percent = translation / presentedVC.view.frame.height
        switch recognizer.state {
        case .began:
            gestureIsBegan = true
            presentedVC.dismiss(animated: true)
            
        case .changed:
            update(percentComplete + percent)
            
        case .ended:
            gestureIsBegan = false
            if percentComplete > 0.5 {
                finish()
            } else {
                cancel()
            }
            
        case .cancelled, .failed:
            cancel()
            
        default:
            break
        }
    }
    
}


//MARK: - Animations


//MARK: Present
final class MenuPresentAnimator_CN: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to)?.view
        else { return }
        let identity = to.frame
        to.frame = to.frame.offsetBy(dx: 0,
                                     dy: to.frame.height)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
            to.frame = identity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}


//MARK: Dismiss
final class MenuDismissAnimator_CN: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from)?.view
        else { return }
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut],
                       animations: {
            from.frame = from.frame.offsetBy(dx: 0,
                                             dy: from.frame.height)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let from = transitionContext.viewController(forKey: .from)?.view ?? UIView()
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                              curve: .easeIn) {
            from.frame = from.frame.offsetBy(dx: 0,
                                             dy: from.frame.height)
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
    
}
