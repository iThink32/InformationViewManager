//
//  SoftAlertView.swift
//  UIComponents
//
//  Created by N A Shashank on 21/04/21.
//  Copyright © 2021 Shashank. All rights reserved.
//

import UIKit

public struct InformationViewDataModel {
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    let titleColor: UIColor
    let font: UIFont
    
    public init(image: UIImage,
                description: String,
                backgroundColor: UIColor,
                titleColor: UIColor,
                font: UIFont) {
        self.image = image
        self.description = description
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.font = font
    }
}

public final class InformationViewManager {
    
    weak var infoView: UIView?
    weak var parentView: UIView?
    var bottomConstraint: NSLayoutConstraint?
    
    private let dynamicAnimator: UIDynamicAnimator
    public init(parentView: UIView) {
        self.parentView = parentView
        self.dynamicAnimator = UIDynamicAnimator(referenceView: parentView)
        //nothing to do here
    }
    
    public func showUsing(dataModel: InformationViewDataModel, positionOffset: CGFloat = 0.0) {
        guard self.infoView == nil,
              let parentView = self.parentView else{
            return
        }
        let containerView = UIView()
        let imageView = UIImageView()
        let label = UILabel()
        label.numberOfLines = 0
        
//        BrentCornerRadiusType.roundedCorner.applyTo(view: containerView)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = CGFloat(8)
        
        parentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor,
                                                                        constant: 15).isActive = true
        containerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                                                          constant: -15).isActive = true
        self.bottomConstraint = containerView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                                                      constant: -10 + positionOffset)
        self.bottomConstraint?.isActive = true
        
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                           constant: 15).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                       constant: 15).isActive = true
        
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                       constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor,
                                   constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                        constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                      constant: -13).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        imageView.image = dataModel.image
        label.textColor = dataModel.titleColor
        label.text = dataModel.description
        label.font = dataModel.font
        containerView.backgroundColor = dataModel.backgroundColor
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gestureRecognizer:)))
        containerView.addGestureRecognizer(pangesture)
        
        self.infoView = containerView
        self.animateAndDismissAlert()
    }
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard let parentView = self.parentView,let softAlertView = self.infoView else{
            return
        }
        switch gestureRecognizer.state {
        case UIGestureRecognizer.State.began:
            self.dynamicAnimator.removeAllBehaviors()
        case UIGestureRecognizer.State.changed:
            let translation = gestureRecognizer.translation(in: parentView)
            self.bottomConstraint?.constant += translation.y
            gestureRecognizer.setTranslation(CGPoint.zero, in: parentView)
            let targetRect = CGRect(x: 0, y: parentView.bounds.height, width: parentView.bounds.width, height: 100)
            guard softAlertView.frame.intersects(targetRect) else{
                return
            }
            let pushBehavior = UIPushBehavior(items: [softAlertView], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: 0, dy: 1.0)
            pushBehavior.magnitude = 0.5
            self.dynamicAnimator.addBehavior(pushBehavior)
            pushBehavior.action = {[weak self] in
                guard let reqdView = self?.infoView, reqdView.frame.origin.y > parentView.bounds.height else{
                    return
                }
                reqdView.removeFromSuperview()
                self?.infoView = nil
                self?.dynamicAnimator.removeAllBehaviors()
            }
        case UIGestureRecognizer.State.ended:
            let velocity = gestureRecognizer.velocity(in: parentView)
            guard velocity.y > 200 else{
                return
            }
            let pushBehavior = UIPushBehavior(items: [softAlertView], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: 0, dy: velocity.y)
            pushBehavior.magnitude = 20
            self.dynamicAnimator.addBehavior(pushBehavior)
            pushBehavior.action = {[weak self] in
                guard let reqdView = self?.infoView, reqdView.frame.origin.y > parentView.bounds.height else{
                    return
                }
                reqdView.removeFromSuperview()
                self?.infoView = nil
                self?.dynamicAnimator.removeAllBehaviors()
            }
        default:
            print("no handler for this case")
        }
    }
    
    private func animateAndDismissAlert() {
        guard let alertView = self.infoView else{
            assertionFailure("could not fetch soft alert instance")
            return
        }
        alertView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction, animations: {[weak alertView] in
            alertView?.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {[weak self] in
            guard let unwrappedSelf = self,
                  let alertView = unwrappedSelf.infoView else{
                print("could not fetch soft alert instance")
                return
            }
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction) {[weak alertView] in
                alertView?.alpha = 0
            } completion: {[weak self] (flag) in
                self?.infoView?.removeFromSuperview()
                self?.infoView = nil
            }
        }
    }
    
}
