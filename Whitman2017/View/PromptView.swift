//
//  PromptView.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/7.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit
import Mapbox

class PromptView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    var leftAccessoryView: UIView = UIView()
    var rightAccessoryView: UIView = UIView()
    weak var delegate: MGLCalloutViewDelegate?
    
    var textView: UITextView
    var backgroundUIImageView: UIImageView
    
    init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        backgroundUIImageView = UIImageView(image: UIImage(asset: .prompt))
        textView = UITextView(frame: .zero)
        super.init(frame: .zero)
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Verlag-Bold", size: 15)
        textView.textColor = UIColor(hex: "#346094")
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.textAlignment = .center
        clipsToBounds = false
        addSubview(backgroundUIImageView)
        addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            return
        }
        view.addSubview(self)
        let title = representedObject.title! ?? ""
        let subTitle = representedObject.subtitle! ?? ""
        textView.text = subTitle.isEmpty ? title : "\(title)\n\n\(subTitle)"
        let screenWidth = UIScreen.main.bounds.width
        textView.sizeToFit()
        if textView.bounds.width > screenWidth / 2 {    // prevent the width too large.
            let newSize = textView.sizeThatFits(CGSize(width: screenWidth / 2.0, height: CGFloat.greatestFiniteMagnitude))
            textView.frame.size = newSize
        }
        backgroundUIImageView.frame = textView.bounds
        backgroundUIImageView.frame.size.height += 20
        let originX = rect.origin.x + (rect.width / 2) - (backgroundUIImageView.bounds.width / 2) + 4
        let originY = rect.origin.y - backgroundUIImageView.bounds.height
        frame = CGRect(x: originX, y: originY, width: backgroundUIImageView.bounds.width, height: backgroundUIImageView.bounds.height)
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        guard let _ = superview else {
            return
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }
}
