//
//  PathMenuItem.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import UIKit

public protocol PathMenuItemDelegate: class {
    func touchesBegin(on item: PathMenuItem)
    func touchesEnd(on item: PathMenuItem)
}

public class PathMenuItem: UIImageView {
    
    public var startPoint: CGPoint = CGPoint.zero
    public var endPoint: CGPoint = CGPoint.zero
    public var nearPoint: CGPoint = CGPoint.zero
    public var farPoint: CGPoint = CGPoint.zero

    public var contentImageView: UIImageView?
    public weak var delegate: PathMenuItemDelegate?
    
    public override var isHighlighted: Bool {
        didSet {
            contentImageView?.isHighlighted = isHighlighted
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    public convenience init(image: UIImage,
        highlightedImage: UIImage? = nil,
        contentImage: UIImage? = nil,
        highlightedContentImage: UIImage? = nil
    ) {
        self.init(frame: CGRect.zero)
        self.image = image
        self.highlightedImage = highlightedImage
        self.contentImageView = UIImageView(image: contentImage)
        self.contentImageView?.highlightedImage = highlightedContentImage
        self.isUserInteractionEnabled = true
        addSubview(contentImageView!)
    }
    
    // MARK: UIView method
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        }
        
        if
            let imageView = contentImageView,
            let width = imageView.image?.size.width,
            let height = imageView.image?.size.height
        {
            let x = bounds.size.width / 2 - width / 2
            let y = bounds.size.height / 2 - height / 2
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        delegate?.touchesBegin(on: self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            if !scale(rect: bounds, n: 2.0).contains(location) {
                isHighlighted = false
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            if scale(rect: bounds, n: 2.0).contains(location) {
                isHighlighted = false
                delegate?.touchesEnd(on: self)
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        isHighlighted = false
    }
    
    // MARK: Private method

    private func scale(rect: CGRect, n: CGFloat) -> CGRect {
        let width = rect.size.width
        let height = rect.size.height
        let x = (width - width * n) / 2
        let y = (height - height * n) / 2
        return CGRect(x: x, y: y, width: width * n, height: height * n)
    }
}
