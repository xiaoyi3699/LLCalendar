//
//  LLUIHelper.swift
//  LLCommonSwift
//
//  Created by chuanshuo on 03/01/2022.
//  Copyright © 2022 WangZhaomeng. All rights reserved.
//

import UIKit

let LL_SCREEN_WIDTH   = UIScreen.main.bounds.size.width
let LL_SCREEN_HEIGHT  = UIScreen.main.bounds.size.width

func LLView(_ frame: CGRect) -> UIView {
    return UIView(frame: frame)
}

func LLLabel(_ frame: CGRect) -> UILabel {
    return UILabel(frame: frame)
}

func LLButton(_ frame: CGRect) -> UIButton {
    return UIButton(frame: frame)
}

func LLImageView(_ frame: CGRect) -> UIImageView {
    return UIImageView(frame: frame)
}

func LLTextField(_ frame: CGRect) -> UITextField {
    return UITextField(frame: frame)
}

func LLTextView(_ frame: CGRect) -> UITextView {
    return UITextView(frame: frame)
}

//先调用子类 再调用父类
extension UIView {
    
    @discardableResult
    func ll_backgroundColor(_ backgroundColor: UIColor) -> UIView {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func ll_contentMode(_ model: ContentMode) -> UIView {
        self.contentMode = model
        return self
    }
    
    @discardableResult
    func ll_isUserInteractionEnabled(_ enabeld: Bool) -> UIView {
        self.isUserInteractionEnabled = enabeld
        return self
    }
    
    @discardableResult
    func ll_cornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> UIView {
        if corners == .allCorners {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = radius
        }
        else {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
        return self
    }
    
    @discardableResult
    func ll_borderWidth(_ width: CGFloat) -> UIView {
        self.layer.borderWidth = width
        return self
    }
    
    @discardableResult
    func ll_borderColor(_ color: UIColor) -> UIView {
        self.layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func ll_tintColor(_ tintColor: UIColor) -> UIView {
        self.tintColor = tintColor
        return self
    }
    
    @discardableResult
    func ll_showInView(_ superview: UIView) -> UIView {
        superview.addSubview(self)
        return self
    }
}

extension UILabel {
    
    @discardableResult
    func ll_text(_ text: String) -> UILabel {
        self.text = text
        return self
    }
    
    @discardableResult
    func ll_attributedText(_ attributedText: NSAttributedString) -> UILabel {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func ll_textAlignment(_ alignment: NSTextAlignment) -> UILabel {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func ll_font(_ font: UIFont) -> UILabel {
        self.font = font
        return self
    }
    
    @discardableResult
    func ll_textColor(_ textColor: UIColor) -> UILabel {
        self.textColor = textColor
        return self
    }
    
    @discardableResult
    func ll_numberOfLines(_ lines: Int) -> UILabel {
        self.numberOfLines = lines
        return self
    }
    
    @discardableResult
    func ll_adjustsFontSizeToFitWidth(_ adjusts: Bool) -> UILabel {
        self.adjustsFontSizeToFitWidth = adjusts
        return self
    }
}

extension UIButton {
    
    @discardableResult
    func ll_font(_ font: UIFont) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func ll_title(_ title: String, _ state: UIControl.State = .normal) -> UIButton {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func ll_titleColor(_ color: UIColor, _ state: UIControl.State = .normal) -> UIButton {
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func ll_image(_ image: UIImage, _ state: UIControl.State = .normal) -> UIButton {
        self.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func ll_adjustsImageWhenHighlighted(_ adjust: Bool) -> UIView {
        self.adjustsImageWhenHighlighted = adjust
        return self
    }
    
    @discardableResult
    func ll_adjustsImageWhenDisabled(_ adjust: Bool) -> UIView {
        self.adjustsImageWhenDisabled = adjust
        return self
    }
    
    @discardableResult
    func ll_addTarget(_ target: Any?, _ action: Selector, _ controlEvents: UIControl.Event = .touchUpInside) -> UIButton {
        self.addTarget(target, action: action, for: controlEvents)
        return self
    }
}

extension UIImageView {
    
    @discardableResult
    func ll_image(_ image: UIImage) -> UIImageView {
        self.image = image
        return self
    }
}

extension UIImage {
    
    @discardableResult
    func ll_renderingMode(_ renderingMode: RenderingMode) -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UITextField {
    
    @discardableResult
    func ll_placeholder(_ placeholder: String?) -> UITextField {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func ll_borderStyle(_ borderStyle: BorderStyle) -> UITextField {
        self.borderStyle = borderStyle
        return self
    }
    
    @discardableResult
    func ll_text(_ text: String) -> UITextField {
        self.text = text
        return self
    }
    
    @discardableResult
    func ll_attributedText(_ attributedText: NSAttributedString) -> UITextField {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func ll_textAlignment(_ alignment: NSTextAlignment) -> UITextField {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func ll_font(_ font: UIFont) -> UITextField {
        self.font = font
        return self
    }
    
    @discardableResult
    func ll_textColor(_ textColor: UIColor) -> UITextField {
        self.textColor = textColor
        return self
    }
}

extension UITextView {
    
    @discardableResult
    func ll_text(_ text: String) -> UITextView {
        self.text = text
        return self
    }
    
    @discardableResult
    func ll_attributedText(_ attributedText: NSAttributedString) -> UITextView {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func ll_textAlignment(_ alignment: NSTextAlignment) -> UITextView {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func ll_font(_ font: UIFont) -> UITextView {
        self.font = font
        return self
    }
    
    @discardableResult
    func ll_textColor(_ textColor: UIColor) -> UITextView {
        self.textColor = textColor
        return self
    }
}
