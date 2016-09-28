//
//  PathMenuItem.swift
//  PathMenu
//
//  Created by Nicolas Charvoz on 09/28/2016.
//  Copyright (c) 2016 Nicolas Charvoz. All rights reserved.
//

import Foundation
import UIKit

public protocol PathMenuItemDelegate: class {
    func pathMenuItemTouchesBegin(_ item: PathMenuItem)
    func pathMenuItemTouchesEnd(_ item: PathMenuItem)
}

open class PathMenuItem: UIImageView {

    open var contentImageView: UIImageView?

    open var startPoint: CGPoint?
    open var endPoint: CGPoint?
    open var nearPoint: CGPoint?
    open var farPoint: CGPoint?

    open weak var delegate: PathMenuItemDelegate?

    override open var isHighlighted: Bool {
        didSet {
            contentImageView?.isHighlighted = isHighlighted
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience public init(image: UIImage,
            highlightedImage himg: UIImage? = nil,
                contentImage cimg: UIImage? = nil,
    highlightedContentImage hcimg: UIImage? = nil) {

        self.init(frame: CGRect.zero)
        self.image = image
        self.highlightedImage = himg
        self.contentImageView = UIImageView(image: cimg)
        self.contentImageView?.highlightedImage = hcimg
        self.isUserInteractionEnabled = true
        self.addSubview(contentImageView!)
    }

    fileprivate func ScaleRect(_ rect: CGRect, n: CGFloat) -> CGRect {
        let width  = rect.size.width
        let height = rect.size.height
        return CGRect(x: (width - width * n)/2, y: (height - height * n)/2, width: width * n, height: height * n)
    }

    //MARK: UIView's methods

    override open func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        }

        if let imageView = contentImageView,
                let width = imageView.image?.size.width,
                    let height = imageView.image?.size.height {

            imageView.frame = CGRect(x: bounds.size.width/2 - width/2, y: bounds.size.height/2 - height/2, width: width, height: height)
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        delegate?.pathMenuItemTouchesBegin(self)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            if !ScaleRect(bounds, n: 2.0).contains(location) {
                isHighlighted = false
            }
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        if let location = touches.first?.location(in: self) {
            if ScaleRect(bounds, n: 2.0).contains(location) {
                delegate?.pathMenuItemTouchesEnd(self)
            }
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
    }
}
