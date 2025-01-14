//
//  LLPopupAnimator.swift
//  LLCommonSwift
//
//  Created by WangZhaomeng on 2018/1/22.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

import UIKit

typealias doBlock = () -> Void

extension UIView {
    
    enum LLPopupType {
        case none
        case center
        case down
    }
    
    func ll_centerAnimation(duration :TimeInterval){
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        let values = NSMutableArray.init(capacity: 2)
        values.add(CATransform3DMakeScale(0.5, 0.5, 1.0))
        values.add(CATransform3DMakeScale(1.0, 1.0, 1.0))
        
        animation.values = values.copy() as? [Any]
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        
        self.layer.add(animation, forKey: "lloutCenter_s")
    }
    
    func ll_dismissToCenterAnimation(duration :TimeInterval) {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform"
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        let values = NSMutableArray.init(capacity: 2)
        values.add(CATransform3DMakeScale(1.0, 1.0, 1.0))
        values.add(CATransform3DMakeScale(0.5, 0.5, 0.5))
        
        animation.values = values.copy() as? [Any]
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))
        
        self.layer.add(animation, forKey: "lloutCenter_d")
    }
    
    func ll_popInView(inView superview: UIView, popupType: LLPopupType) {
        if popupType == .center {
            LLPopupAnimator.animator.popUp(view: self, style: .center, inView: superview, completion: nil)
        }
        else if popupType == .down {
            LLPopupAnimator.animator.popUp(view: self, style: .down, inView: superview, completion: nil)
        }
        else {
            superview.addSubview(self)
        }
    }
    
    func ll_dismiss() {
        LLPopupAnimator.animator.dismiss()
    }
}

class LLPopupAnimator: UIView {

    var isShow = false
    private weak var alertView : UIView?
    private var animationStyle : LLPopupType?
    static let animator = LLPopupAnimator()
    
    //私有化初始化方法，防止外部通过init直接创建实例。
    private init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.init(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///弹出视图
    func popUp(view: UIView, style: LLPopupType, inView: UIView, completion: (doBlock?) = nil) {
        if self.isShow == true {
            self.dismiss()
        }
        self.isShow = true
        self.frame = inView.bounds
        if ((alertView?.superview) != nil) {
            alertView?.removeFromSuperview()
        }
        if ((self.superview) != nil) {
            self.removeFromSuperview()
        }
        alertView = view
        animationStyle = style
        
        if (animationStyle == .down) {
            
            var rect = view.frame
            rect.origin.x = 0.0
            rect.origin.y = self.bounds.size.height
            
            view.frame = rect
            self.addSubview(view)
            inView.addSubview(self)
            
            self.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1.0
                var frame = view.frame
                frame.origin.y = self.bounds.size.height-CGFloat(round((rect.size.height)))
                view.frame = frame
            }, completion: {_ in
                completion?()
            })
        }
        else {
            var rect = view.frame
            let alertW = rect.size.width
            let alerth = rect.size.height
            
            rect.origin.x = CGFloat(round(self.bounds.size.width-alertW)/2.0)
            rect.origin.y = CGFloat(round(self.bounds.size.height-alerth)/2.0)-40.0
            
            view.frame = rect
            self.addSubview(view)
            inView.addSubview(self)
            
            if (animationStyle == .center) {
                view.ll_centerAnimation(duration: 0.3)
            }
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
            }, completion: {_ in
                completion?()
            })
        }
    }
    
    ///视图消失
    func dismiss(_ completion: doBlock? = nil) {
        if self.isShow == false {
            return
        }
        self.isShow = false
        if (animationStyle == .down) {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.0
                var rect = self.alertView?.frame
                rect?.origin.y = self.bounds.size.height
                self.alertView?.frame = rect!
            }, completion: {_ in
                self.alertView?.removeFromSuperview()
                self.removeFromSuperview()
                completion?()
            })
        }
        else {
            if (animationStyle == .center) {
                self.alertView?.ll_dismissToCenterAnimation(duration: 0.2)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.0
            }, completion: {_ in
                self.alertView?.removeFromSuperview()
                self.removeFromSuperview()
                completion?()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (animationStyle == .down) {
            self.dismiss()
        }
    }
}
