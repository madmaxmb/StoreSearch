//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Максим on 06.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class DimmingPresentationController: UIPresentationController {
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, atIndex: 0)
        
        dimmingView.alpha = 0
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ _ in
                self.dimmingView.alpha = 1}, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCooperation = presentedViewController.transitionCoordinator() {
            transitionCooperation.animateAlongsideTransition({ _ in
                self.dimmingView.alpha = 0}, completion: nil)
        }
    }
}
