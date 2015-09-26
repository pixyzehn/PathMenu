//
//  PathMenuItem.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

public protocol PathMenuItemDelegate: class {
    func pathMenuItemTouchesBegin(item: PathMenuItem)
    func pathMenuItemTouchesEnd(item: PathMenuItem)
}

public class PathMenuItem: UIImageView {
    
    public var contentImageView: UIImageView?

    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    public var nearPoint: CGPoint?
    public var farPoint: CGPoint?
    
    public weak var delegate: PathMenuItemDelegate?
    
    override public var highlighted: Bool {
        didSet {
            contentImageView?.highlighted = highlighted
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

        self.init(frame: CGRectZero)
        self.image = image
        self.highlightedImage = himg
        self.contentImageView = UIImageView(image: cimg)
        self.contentImageView?.highlightedImage = hcimg
        self.userInteractionEnabled = true
        self.addSubview(contentImageView!)
    }

    private func ScaleRect(rect: CGRect, n: CGFloat) -> CGRect {
        let width  = rect.size.width
        let height = rect.size.height
        return CGRectMake((width - width * n)/2, (height - height * n)/2, width * n, height * n)
    }

    //MARK: UIView's methods
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            bounds = CGRectMake(0, 0, image.size.width, image.size.height)
        }
        
        if let imageView = contentImageView,
                let width = imageView.image?.size.width,
                    let height = imageView.image?.size.height {

            imageView.frame = CGRectMake(bounds.size.width/2 - width/2, bounds.size.height/2 - height/2, width, height)
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        highlighted = true
        delegate?.pathMenuItemTouchesBegin(self)
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let location = touches.first?.locationInView(self) {
            if !CGRectContainsPoint(ScaleRect(bounds, n: 2.0), location) {
                highlighted = false
            }
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        highlighted = false
        if let location = touches.first?.locationInView(self) {
            if CGRectContainsPoint(ScaleRect(bounds, n: 2.0), location) {
                delegate?.pathMenuItemTouchesEnd(self)
            }
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        highlighted = false
    }
}
