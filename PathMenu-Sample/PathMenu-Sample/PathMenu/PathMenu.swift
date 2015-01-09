//
//  PathMenu.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PathMenuDelegate:NSObjectProtocol {
    optional func pathMenu(menu: PathMenu, didSelectIndex idx: Int)
    optional func pathMenuDidFinishAnimationClose(menu: PathMenu)
    optional func pathMenuDidFinishAnimationOpen(menu: PathMenu)
    optional func pathMenuWillAnimateOpen(menu: PathMenu)
    optional func pathMenuWillAnimateClose(menu: PathMenu)
}

let kPathMenuDefaultNearRadius: CGFloat = 110.0
let kPathMenuDefaultEndRadius: CGFloat = 120.0
let kPathMenuDefaultFarRadius: CGFloat = 140.0
let kPathMenuDefaultStartPointX: CGFloat = UIScreen.mainScreen().bounds.width/2
let kPathMenuDefaultStartPointY: CGFloat = UIScreen.mainScreen().bounds.height/2
let kPathMenuDefaultTimeOffset: CGFloat = 0.036
let kPathMenuDefaultRotateAngle: CGFloat = 0.0
let kPathMenuDefaultMenuWholeAngle: CGFloat = CGFloat(M_PI) * 2
let kPathMenuDefaultExpandRotation: CGFloat = -CGFloat(M_PI) * 2
let kPathMenuDefaultCloseRotation: CGFloat = CGFloat(M_PI) * 2
let kPathMenuDefaultAnimationDuration: CGFloat = 0.5
let kPathMenuDefaultExpandRotateAnimationDuration: CGFloat = 2.0
let kPathMenuDefaultCloseRotateAnimationDuration: CGFloat = 1.0
let kPathMenuStartMenuDefaultAnimationDuration: CGFloat = 0.2

private func RotateCGPointAroundCenter(point: CGPoint, center:CGPoint, angle: CGFloat) -> CGPoint {
    let translation: CGAffineTransform = CGAffineTransformMakeTranslation(center.x, center.y)
    let rotation: CGAffineTransform = CGAffineTransformMakeRotation(angle)
    let transformGroup: CGAffineTransform = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation)
    return CGPointApplyAffineTransform(point, transformGroup)
}

class PathMenu: UIView, PathMenuItemDelegate {
   
    enum State {
        case Close // Intial state
        case Expand
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect!, startItem: PathMenuItem?, optionMenus aMenusArray:[PathMenuItem]?) {
        self.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.timeOffset = kPathMenuDefaultTimeOffset
        self.rotateAngle = kPathMenuDefaultRotateAngle
        self.menuWholeAngle = kPathMenuDefaultMenuWholeAngle
        self.startPoint = CGPointMake(kPathMenuDefaultStartPointX, kPathMenuDefaultStartPointY)
        self.expandRotation = kPathMenuDefaultExpandRotation
        self.closeRotation = kPathMenuDefaultCloseRotation
        self.animationDuration = kPathMenuDefaultAnimationDuration
        self.expandRotateAnimationDuration = kPathMenuDefaultExpandRotateAnimationDuration
        self.closeRotateAnimationDuration = kPathMenuDefaultCloseRotateAnimationDuration
        self.startMenuAnimationDuration = kPathMenuStartMenuDefaultAnimationDuration
        self.rotateAddButton = true
        
        self.nearRadius = kPathMenuDefaultNearRadius
        self.endRadius = kPathMenuDefaultEndRadius
        self.farRadius = kPathMenuDefaultFarRadius
 
        self.menusArray = aMenusArray!
        
        self.motionState = State.Close
        
        self.startButton = startItem!
        self.startButton.delegate = self
        self.startButton.center = self.startPoint
        self.addSubview(self.startButton)
    }

    var _menusArray: [PathMenuItem] = []
    var menusArray: [PathMenuItem] {
        get {
            return self._menusArray
        }
        set(newArray) {
            self._menusArray = newArray
            for v in self.subviews {
                if v.tag >= 1000 {
                    v.removeFromSuperview()
                }
            }
        }
    }
    
    var _startButton: PathMenuItem = PathMenuItem(frame: CGRectZero)
    var startButton: PathMenuItem {
        get {
            return self._startButton
        }
        set {
            self._startButton = newValue
        }
    }
    
    weak var delegate: PathMenuDelegate!

    var flag: Int?
    var timer: NSTimer?
    
    var timeOffset: CGFloat!
    var rotateAngle: CGFloat!
    var menuWholeAngle: CGFloat!
    var expandRotation: CGFloat!
    var closeRotation: CGFloat!
    var animationDuration: CGFloat!
    var expandRotateAnimationDuration: CGFloat!
    var closeRotateAnimationDuration: CGFloat!
    var startMenuAnimationDuration: CGFloat!
    var rotateAddButton: Bool!
    
    var nearRadius: CGFloat!
    var endRadius: CGFloat!
    var farRadius: CGFloat!
    
    var motionState: State?
    
    var _startPoint: CGPoint = CGPointZero
    var startPoint: CGPoint {
        get {
            return self._startPoint
        }
        set {
            self._startPoint = newValue
            self.startButton.center = newValue
        }
    }
    
    // Image
    
    var _image = UIImage()
    var image: UIImage? {
        get {
            return self.startButton.image
        }
        set(newImage) {
            self.startButton.image = newImage
        }
    }
    
    var highlightedImage: UIImage? {
        get {
            return self.startButton.highlightedImage
        }
        set(newImage) {
            self.startButton.highlightedImage = newImage
        }
    }
    
    var contentImage: UIImage? {
        get {
            return self.startButton.contentImageView?.image
        }
        set {
            self.startButton.contentImageView?.image = newValue
        }
    }
    
    var highlightedContentImage: UIImage? {
        get {
            return self.startButton.contentImageView?.highlightedImage
        }
        set {
            self.startButton.contentImageView?.highlightedImage = newValue
        }
    }
    
    // UIView's methods
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if self.motionState == State.Expand {
            return true
        } else {
            // Close
            return CGRectContainsPoint(self.startButton.frame, point)
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if let animId: AnyObject = anim.valueForKey("id") {
            if (animId.isEqual("lastAnimation")) {
                self.delegate?.pathMenuDidFinishAnimationClose?(self)
            }
            if (animId.isEqual("firstAnimation")) {
                self.delegate?.pathMenuDidFinishAnimationOpen?(self)
            }
        }
    }
    
    // UIGestureRecognizer
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.handleTap()
    }
    
    // PathMenuItemDelegate
    
    func PathMenuItemTouchesBegan(item: PathMenuItem) {
        if (item == self.startButton) {
            self.handleTap()
        }
    }
    
    func PathMenuItemTouchesEnd(item:PathMenuItem) {
        
        if (item == self.startButton) {
            return
        }
        
        let blowup: CAAnimationGroup = self.blowupAnimationAtPoint(item.center)
        item.layer.addAnimation(blowup, forKey: "blowup")
        item.center = item.startPoint!
        
        for (var i = 0; i < self.menusArray.count; i++) {
            let otherItem: PathMenuItem = self.menusArray[i] as PathMenuItem
            let shrink: CAAnimationGroup = self.shrinkAnimationAtPoint(otherItem.center)
            if (otherItem.tag == item.tag) {
                continue
            }
            otherItem.layer.addAnimation(shrink, forKey: "shrink")
            otherItem.center = otherItem.startPoint!
        }
        
        self.motionState = State.Close
        self.delegate?.pathMenuWillAnimateClose?(self)
        
        let angle: CGFloat = self.motionState == State.Expand ? CGFloat(M_PI_4) + CGFloat(M_PI) : 0.0
        UIView.animateWithDuration(Double(self.startMenuAnimationDuration!), animations: {() -> Void in
            self.startButton.transform = CGAffineTransformMakeRotation(angle)
        })
        
        self.delegate?.pathMenu?(self, didSelectIndex: item.tag - 1000)
    }
    
    // Animation, Position
    
    func handleTap() {
        var state = self.motionState!
        var selector: Selector?
        var angle: CGFloat?
        
        switch state {
        case .Close:
            self.setMenu()
            self.delegate?.pathMenuWillAnimateOpen?(self)
            selector = "expand"
            self.flag = 0
            self.motionState = State.Expand
            angle = CGFloat(M_PI_4) + CGFloat(M_PI)
        case .Expand:
            self.delegate?.pathMenuWillAnimateClose?(self)
            selector = "close"
            self.flag = self.menusArray.count - 1
            self.motionState = State.Close
            angle = 0.0
        }
        
        if let rotateAddButton = self.rotateAddButton {
            UIView.animateWithDuration(Double(self.startMenuAnimationDuration!), animations: { () -> Void in
                self.startButton.transform = CGAffineTransformMakeRotation(angle!)
            })
        }
        
        if (timer == nil) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(timeOffset!), target: self, selector: selector!, userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    func expand() {
        
        if self.flag == self.menusArray.count {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        let tag: Int = 1000 + self.flag!
        var item: PathMenuItem = self.viewWithTag(tag) as PathMenuItem
        
        let rotateAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [NSNumber(float: 0.0), NSNumber(float: Float(self.expandRotation!)), NSNumber(float: 0.0)]
        rotateAnimation.duration = CFTimeInterval(self.expandRotateAnimationDuration!)
        rotateAnimation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.4), NSNumber(float: 0.5)]
        
        let positionAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(self.animationDuration!)
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, CGFloat(item.startPoint!.x), CGFloat(item.startPoint!.y))
        CGPathAddLineToPoint(path, nil, item.farPoint!.x, item.farPoint!.y)
        CGPathAddLineToPoint(path, nil, item.nearPoint!.x, item.nearPoint!.y)
        CGPathAddLineToPoint(path, nil, item.endPoint!.x, item.endPoint!.y)
        positionAnimation.path = path
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation]
        animationgroup.duration = CFTimeInterval(self.animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self
        
        if self.flag == (self.menusArray.count - 1) {
            animationgroup.setValue("firstAnimation", forKey: "id")
        }
        
        item.layer.addAnimation(animationgroup, forKey: "Expand")
        item.center = item.endPoint!
        
        self.flag!++
    }
    
    func close() {
        
        if (self.flag! == -1)
        {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        let tag :Int = 1000 + self.flag!
        var item: PathMenuItem = self.viewWithTag(tag) as PathMenuItem
        
        let rotateAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [NSNumber(float: 0.0), NSNumber(float: Float(self.closeRotation!)), NSNumber(float: 0.0)]
        rotateAnimation.duration = CFTimeInterval(self.closeRotateAnimationDuration!)
        rotateAnimation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.4), NSNumber(float: 0.5)]
        
        let positionAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(self.animationDuration!)
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, item.endPoint!.x, item.endPoint!.y)
        CGPathAddLineToPoint(path, nil, item.farPoint!.x, item.farPoint!.y)
        CGPathAddLineToPoint(path, nil, CGFloat(item.startPoint!.x), CGFloat(item.startPoint!.y))
        positionAnimation.path = path
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation]
        animationgroup.duration = CFTimeInterval(self.animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self

        if self.flag == 0 {
            animationgroup.setValue("lastAnimation", forKey: "id")
        }
        
        item.layer.addAnimation(animationgroup, forKey: "Close")
        item.center = item.startPoint!
        
        self.flag!--
    }
    
    func setMenu() {
        let count: Int = self.menusArray.count
        
        for (var i = 0; i < self.menusArray.count; i++) {
            var item: PathMenuItem = self.menusArray[i]
            item.tag = 1000 + i
            item.startPoint = self.startPoint
            
            // avoid overlap
            if (menuWholeAngle >= CGFloat(M_PI) * 2) {
                menuWholeAngle = menuWholeAngle! - menuWholeAngle! / CGFloat(count)
            }
            
            let i1 = Float(self.endRadius) * sinf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let i2 = Float(self.endRadius) * cosf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let endPoint: CGPoint = CGPointMake(startPoint.x + CGFloat(i1), startPoint.y - CGFloat(i2))
            item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle!)
            
            let j1 = Float(self.nearRadius) * sinf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let j2 = Float(self.nearRadius) * cosf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let nearPoint: CGPoint = CGPointMake(startPoint.x + CGFloat(j1), startPoint.y - CGFloat(j2))
            item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, rotateAngle!)

            let k1 = Float(self.farRadius) * sinf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let k2 = Float(self.farRadius) * cosf(Float(i) * Float(menuWholeAngle!) / Float(count - 1))
            let farPoint: CGPoint = CGPointMake(startPoint.x + CGFloat(k1), startPoint.y - CGFloat(k2))
            item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, rotateAngle!)
            
            item.center = item.startPoint!
            item.delegate = self

            self.insertSubview(item, belowSubview: self.startButton)
        }
    }
    
    func blowupAnimationAtPoint(p: CGPoint) -> CAAnimationGroup {
        let positionAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(CGPoint: p)]
        positionAnimation.keyTimes = [3]
 
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(3, 3, 1))
        
        let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(float: 0.0)
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(self.animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
    
    func shrinkAnimationAtPoint(p: CGPoint) -> CAAnimationGroup {
        let positionAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(CGPoint: p)]
        positionAnimation.keyTimes = [3]
        
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 1))

        let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(float: 0.0)
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(self.animationDuration!)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
}
