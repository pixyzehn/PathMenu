//
//  PathMenu.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

public protocol PathMenuDelegate: class {
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int)
    func pathMenuDidFinishAnimationClose(menu: PathMenu)
    func pathMenuDidFinishAnimationOpen(menu: PathMenu)
    func pathMenuWillAnimateOpen(menu: PathMenu)
    func pathMenuWillAnimateClose(menu: PathMenu)
}

public class PathMenu: UIView, PathMenuItemDelegate {
    
    struct Radius {
        static var Near: CGFloat = 110.0
        static var End: CGFloat  = 120.0
        static var Far: CGFloat  = 140.0
    }
    
    struct Duration {
        static var DefaultAnimation: CGFloat      = 0.5
        static var ExpandRotateAnimation: CGFloat = 2.0
        static var CloseRotateAnimation: CGFloat  = 1.0
        static var MenuDefaultAnimation: CGFloat  = 0.2
    }
    
    struct Angle {
        static var DefaultRotation: CGFloat   = 0.0
        static var MenuWholeRotation: CGFloat = CGFloat(M_PI * 2)
        static var ExpandRotation: CGFloat    = -CGFloat(M_PI * 2)
        static var CloseRotation: CGFloat     = CGFloat(M_PI * 2)
    }
   
    public enum State {
        case Close
        case Expand
    }
        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect!, startItem: PathMenuItem?, items:[PathMenuItem]?) {
        self.init(frame: frame)
        self.timeOffset = 0.036

        self.nearRadius = Radius.Near
        self.endRadius  = Radius.End
        self.farRadius  = Radius.Far

        self.animationDuration             = Duration.DefaultAnimation
        self.expandRotateAnimationDuration = Duration.DefaultAnimation
        self.closeRotateAnimationDuration  = Duration.CloseRotateAnimation
        self.startMenuAnimationDuration    = Duration.MenuDefaultAnimation

        self.rotateAngle    = Angle.DefaultRotation
        self.menuWholeAngle = Angle.MenuWholeRotation
        self.expandRotation = Angle.ExpandRotation
        self.closeRotation  = Angle.CloseRotation

        self.startPoint = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
 
        self.menuItems = items ?? []
        self.motionState = .Close
        
        self.startButton = startItem
        self.startButton!.delegate = self
        self.startButton!.center = startPoint
        self.addSubview(startButton!)
    }

    public var menuItems: [PathMenuItem] = [] {
        didSet {
            for view in subviews {
                if view.tag >= 1000 {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    public var startButton: PathMenuItem?
    public weak var delegate: PathMenuDelegate?

    public var flag: Int?
    public var timer: NSTimer?
    
    public var timeOffset: CGFloat!

    public var rotateAngle: CGFloat!
    public var menuWholeAngle: CGFloat!
    public var expandRotation: CGFloat!
    public var closeRotation: CGFloat!

    public var animationDuration: CGFloat!
    public var expandRotateAnimationDuration: CGFloat!
    public var closeRotateAnimationDuration: CGFloat!
    public var startMenuAnimationDuration: CGFloat!
    
    public var nearRadius: CGFloat!
    public var endRadius: CGFloat!
    public var farRadius: CGFloat!
    
    public var motionState: State?
    
    public var startPoint: CGPoint = CGPointZero {
        didSet {
            startButton?.center = startPoint
        }
    }
    
    //MARK: Image
    
    public var image: UIImage? {
        didSet {
            startButton?.image = image
        }
    }

    public var highlightedImage: UIImage? {
        didSet {
            startButton?.highlightedImage = highlightedImage
        }
    }
    
    public var contentImage: UIImage? {
        didSet {
            startButton?.contentImageView?.image = contentImage
        }
    }
    
    public var highlightedContentImage: UIImage? {
        didSet {
            startButton?.contentImageView?.highlightedImage = highlightedContentImage
        }
    }
    
    //MARK: UIView's methods
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if motionState == .Expand { return true }
        return CGRectContainsPoint(startButton!.frame, point)
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let animId = anim.valueForKey("id") {
            if animId.isEqual("lastAnimation") {
                delegate?.pathMenuDidFinishAnimationClose(self)
            }
            if animId.isEqual("firstAnimation") {
                delegate?.pathMenuDidFinishAnimationOpen(self)
            }
        }
    }
    
    //MARK: UIGestureRecognizer
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTap()
    }
    
    //MARK: PathMenuItemDelegate
    
    public func pathMenuItemTouchesBegin(item: PathMenuItem) {
        if item == startButton { handleTap() }
    }
    
    public func pathMenuItemTouchesEnd(item:PathMenuItem) {
        if item == startButton { return }
        
        let blowup = blowupAnimationAtPoint(item.center)
        item.layer.addAnimation(blowup, forKey: "blowup")
        item.center = item.startPoint!

        for (_, menuItem) in menuItems.enumerate() {
            let otherItem = menuItem
            let shrink = shrinkAnimationAtPoint(otherItem.center)
            
            if otherItem.tag == item.tag { continue }
            otherItem.layer.addAnimation(shrink, forKey: "shrink")
            otherItem.center = otherItem.startPoint!
        }
        
        motionState = .Close
        delegate?.pathMenuWillAnimateClose(self)
        
        let angle = motionState == .Expand ? CGFloat(M_PI_4) + CGFloat(M_PI) : 0.0
        UIView.animateWithDuration(Double(startMenuAnimationDuration!), animations: { [weak self] () -> Void in
            self?.startButton?.transform = CGAffineTransformMakeRotation(angle)
        })
        
        delegate?.pathMenu(self, didSelectIndex: item.tag - 1000)
    }
    
    //MARK: Animation, Position
    
    public func handleTap() {
        let state = motionState!

        let selector: Selector
        let angle: CGFloat
        
        switch state {
        case .Close:
            setMenu()
            delegate?.pathMenuWillAnimateOpen(self)
            selector = "expand"
            flag = 0
            motionState = .Expand
            angle = CGFloat(M_PI_4) + CGFloat(M_PI)
        case .Expand:
            delegate?.pathMenuWillAnimateClose(self)
            selector = "close"
            flag = menuItems.count - 1
            motionState = .Close
            angle = 0
        }
        
        UIView.animateWithDuration(Double(startMenuAnimationDuration!), animations: { [weak self] () -> Void in
            self?.startButton?.transform = CGAffineTransformMakeRotation(angle)
        })
        
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(timeOffset!), target: self, selector: selector, userInfo: nil, repeats: true)
            if let timer = timer {
                NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            }
        }
    }
    
    public func expand() {
        if flag == menuItems.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let tag = 1000 + flag!
        let item = viewWithTag(tag) as! PathMenuItem
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values   = [NSNumber(float: 0.0), NSNumber(float: Float(expandRotation!)), NSNumber(float: 0.0)]
        rotateAnimation.duration = CFTimeInterval(expandRotateAnimationDuration!)
        rotateAnimation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.4), NSNumber(float: 0.5)]
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(animationDuration!)

        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, CGFloat(item.startPoint!.x), CGFloat(item.startPoint!.y))
        CGPathAddLineToPoint(path, nil, item.farPoint!.x, item.farPoint!.y)
        CGPathAddLineToPoint(path, nil, item.nearPoint!.x, item.nearPoint!.y)
        CGPathAddLineToPoint(path, nil, item.endPoint!.x, item.endPoint!.y)
        positionAnimation.path = path
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations     = [positionAnimation, rotateAnimation]
        animationgroup.duration       = CFTimeInterval(animationDuration!)
        animationgroup.fillMode       = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self
        
        if flag == menuItems.count - 1 {
            animationgroup.setValue("firstAnimation", forKey: "id")
        }
        
        item.layer.addAnimation(animationgroup, forKey: "Expand")
        item.center = item.endPoint!
        
        flag!++
    }
    
    public func close() {
        if flag! == -1 {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let tag = 1000 + flag!
        let item = viewWithTag(tag) as! PathMenuItem
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values   = [NSNumber(float: 0.0), NSNumber(float: Float(closeRotation!)), NSNumber(float: 0.0)]
        rotateAnimation.duration = CFTimeInterval(closeRotateAnimationDuration!)
        rotateAnimation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.4), NSNumber(float: 0.5)]
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(animationDuration!)
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, item.endPoint!.x, item.endPoint!.y)
        CGPathAddLineToPoint(path, nil, item.farPoint!.x, item.farPoint!.y)
        CGPathAddLineToPoint(path, nil, CGFloat(item.startPoint!.x), CGFloat(item.startPoint!.y))
        positionAnimation.path = path
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations     = [positionAnimation, rotateAnimation]
        animationgroup.duration       = CFTimeInterval(animationDuration!)
        animationgroup.fillMode       = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self

        if flag == 0 {
            animationgroup.setValue("lastAnimation", forKey: "id")
        }
        
        item.layer.addAnimation(animationgroup, forKey: "Close")
        item.center = item.startPoint!
        
        flag!--
    }
    
    public func setMenu() {
        let count = menuItems.count
        var denominator: Int?
        
        for (index, menuItem) in menuItems.enumerate() {
            let item = menuItem
            item.tag = 1000 + index
            item.startPoint = startPoint
            
            if menuWholeAngle >= CGFloat(M_PI) * 2 {
                menuWholeAngle = menuWholeAngle! - menuWholeAngle! / CGFloat(count)
            }
            
            denominator = count == 1 ? 1 : count - 1
            
            let i1 = Float(endRadius) * sinf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let i2 = Float(endRadius) * cosf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let endPoint = CGPointMake(startPoint.x + CGFloat(i1), startPoint.y - CGFloat(i2))
            item.endPoint = RotateCGPointAroundCenter(endPoint, center: startPoint, angle: rotateAngle!)
            
            let j1 = Float(nearRadius) * sinf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let j2 = Float(nearRadius) * cosf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let nearPoint = CGPointMake(startPoint.x + CGFloat(j1), startPoint.y - CGFloat(j2))
            item.nearPoint = RotateCGPointAroundCenter(nearPoint, center: startPoint, angle: rotateAngle!)

            let k1 = Float(farRadius) * sinf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let k2 = Float(farRadius) * cosf(Float(index) * Float(menuWholeAngle!) / Float(denominator!))
            let farPoint = CGPointMake(startPoint.x + CGFloat(k1), startPoint.y - CGFloat(k2))
            item.farPoint = RotateCGPointAroundCenter(farPoint, center: startPoint, angle: rotateAngle!)
            
            item.center = item.startPoint!
            item.delegate = self

            insertSubview(item, belowSubview: startButton!)
        }
    }
    
    private func RotateCGPointAroundCenter(point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        let translation = CGAffineTransformMakeTranslation(center.x, center.y)
        let rotation = CGAffineTransformMakeRotation(angle)
        let transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation)
        return CGPointApplyAffineTransform(point, transformGroup)
    }
    
    private func blowupAnimationAtPoint(p: CGPoint) -> CAAnimationGroup {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(CGPoint: p)]
        positionAnimation.keyTimes = [3]
 
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(3, 3, 1))
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(float: 0.0)
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
    
    private func shrinkAnimationAtPoint(p: CGPoint) -> CAAnimationGroup {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(CGPoint: p)]
        positionAnimation.keyTimes = [3]
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 1))

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(float: 0.0)
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
}
