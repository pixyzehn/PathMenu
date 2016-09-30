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
    func didSelect(on menu: PathMenu, index: Int)
    func didFinishAnimationClose(on menu: PathMenu)
    func didFinishAnimationOpen(on menu: PathMenu)
    func willStartAnimationOpen(on menu: PathMenu)
    func willStartAnimationClose(on menu: PathMenu)
}

public class PathMenu: UIView {
    
    struct Radius {
        static var near: CGFloat = 110.0
        static var end: CGFloat = 120.0
        static var far: CGFloat = 140.0
    }
    
    struct Duration {
        static var defaultAnimation: CGFloat = 0.5
        static var expandRotateAnimation: CGFloat = 2.0
        static var closeRotateAnimation: CGFloat = 1.0
        static var menuDefaultAnimation: CGFloat = 0.2
    }
    
    struct Angle {
        static var defaultRotation: CGFloat = 0.0
        static var menuWholeRotation: CGFloat = CGFloat(M_PI * 2)
        static var expandRotation: CGFloat = -CGFloat(M_PI * 2)
        static var closeRotation: CGFloat = CGFloat(M_PI * 2)
    }
   
    public enum State {
        case close
        case expand
    }
        
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(frame: CGRect, startItem: PathMenuItem, items:[PathMenuItem]) {
        self.init(frame: frame)

        self.startPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        self.menuItems = items
        
        self.startButton = startItem
        self.startButton?.delegate = self
        self.startButton?.center = startPoint
        addSubview(startButton!)
    }

    public var menuItems: [PathMenuItem] = [] {
        didSet {
            for view in subviews where view.tag >= 1000 {
                view.removeFromSuperview()
            }
        }
    }
    
    public var startButton: PathMenuItem?
    public weak var delegate: PathMenuDelegate?

    public var flag: Int = 0
    public var timer: Timer?
    
    public var timeOffset: CGFloat = 0.036

    public var rotateAngle = Angle.defaultRotation
    public var menuWholeAngle = Angle.menuWholeRotation
    public var expandRotation = Angle.expandRotation
    public var closeRotation = Angle.closeRotation

    public var animationDuration = Duration.defaultAnimation
    public var expandRotateAnimationDuration = Duration.expandRotateAnimation
    public var closeRotateAnimationDuration = Duration.closeRotateAnimation
    public var startMenuAnimationDuration = Duration.menuDefaultAnimation
    
    public var nearRadius = Radius.near
    public var endRadius = Radius.end
    public var farRadius = Radius.far
    
    public var motionState: State = .close
    
    public var startPoint: CGPoint = CGPoint.zero {
        didSet {
            startButton?.center = startPoint
        }
    }
    
    // MARK: Image
    
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
    
    //MARK: UIView method
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if motionState == .expand { return true }
        return startButton?.frame.contains(point) ?? false
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTap()
    }
    
    //MARK: Animation and Position
    
    public func handleTap() {
        let selector: Selector
        let angle: CGFloat
        
        switch motionState {
        case .close:
            setMenu()
            delegate?.willStartAnimationOpen(on: self)
            selector = #selector(expand)
            flag = 0
            motionState = .expand
            angle = CGFloat(M_PI_4) + CGFloat(M_PI)
        case .expand:
            delegate?.willStartAnimationClose(on: self)
            selector = #selector(close)
            flag = menuItems.count - 1
            motionState = .close
            angle = 0
        }
        
        UIView.animate(withDuration: Double(startMenuAnimationDuration)) { [weak self] () -> Void in
            self?.startButton?.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Double(timeOffset), target: self, selector: selector, userInfo: nil, repeats: true)
            if let timer = timer {
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    public func expand() {
        if flag == menuItems.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let tag = 1000 + flag
        let item = viewWithTag(tag) as! PathMenuItem
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [NSNumber(value: 0.0), NSNumber(value: Float(expandRotation)), NSNumber(value: 0.0)]
        rotateAnimation.duration = CFTimeInterval(expandRotateAnimationDuration)
        rotateAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.4), NSNumber(value: 0.5)]
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(animationDuration)

        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(item.startPoint.x), y: CGFloat(item.startPoint.y)))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.nearPoint.x, y: item.nearPoint.y))
        path.addLine(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        positionAnimation.path = path
        
        let animationgroup: CAAnimationGroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration)
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self
        
        if flag == menuItems.count - 1 {
            animationgroup.setValue("firstAnimation", forKey: "id")
        }
        
        item.layer.add(animationgroup, forKey: "Expand")
        item.center = item.endPoint
        
        flag += 1
    }
    
    public func close() {
        if flag == -1 {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let tag = 1000 + flag
        let item = viewWithTag(tag) as! PathMenuItem
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [NSNumber(value: 0.0), NSNumber(value: Float(closeRotation)), NSNumber(value: 0.0)]
        rotateAnimation.duration = CFTimeInterval(closeRotateAnimationDuration)
        rotateAnimation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.4), NSNumber(value: 0.5)]
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = CFTimeInterval(animationDuration)
        let path = CGMutablePath()
        path.move(to: CGPoint(x: item.endPoint.x, y: item.endPoint.y))
        path.addLine(to: CGPoint(x: item.farPoint.x, y: item.farPoint.y))
        path.addLine(to: CGPoint(x: item.startPoint.x, y: item.startPoint.y))
        positionAnimation.path = path
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, rotateAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration)
        animationgroup.fillMode = kCAFillModeForwards
        animationgroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animationgroup.delegate = self

        if flag == 0 {
            animationgroup.setValue("lastAnimation", forKey: "id")
        }
        
        item.layer.add(animationgroup, forKey: "Close")
        item.center = item.startPoint
        
        flag -= 1
    }
    
    public func setMenu() {
        let count = menuItems.count
        var denominator: Int?
        
        for (index, menuItem) in menuItems.enumerated() {
            let item = menuItem
            item.tag = 1000 + index
            item.startPoint = startPoint
            
            if menuWholeAngle >= CGFloat(M_PI) * 2 {
                menuWholeAngle = menuWholeAngle - menuWholeAngle / CGFloat(count)
            }
            
            denominator = count == 1 ? 1 : count - 1
            
            let i1 = Float(endRadius) * sinf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let i2 = Float(endRadius) * cosf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let endPoint = CGPoint(x: startPoint.x + CGFloat(i1), y: startPoint.y - CGFloat(i2))
            item.endPoint = rotateAroundCenter(at: endPoint, center: startPoint, angle: rotateAngle)
            
            let j1 = Float(nearRadius) * sinf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let j2 = Float(nearRadius) * cosf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let nearPoint = CGPoint(x: startPoint.x + CGFloat(j1), y: startPoint.y - CGFloat(j2))
            item.nearPoint = rotateAroundCenter(at: nearPoint, center: startPoint, angle: rotateAngle)

            let k1 = Float(farRadius) * sinf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let k2 = Float(farRadius) * cosf(Float(index) * Float(menuWholeAngle) / Float(denominator!))
            let farPoint = CGPoint(x: startPoint.x + CGFloat(k1), y: startPoint.y - CGFloat(k2))
            item.farPoint = rotateAroundCenter(at: farPoint, center: startPoint, angle: rotateAngle)
            
            item.center = item.startPoint
            item.delegate = self

            insertSubview(item, belowSubview: startButton!)
        }
    }
    
    private func rotateAroundCenter(at point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        let translation = CGAffineTransform(translationX: center.x, y: center.y)
        let rotation = CGAffineTransform(rotationAngle: angle)
        let transformGroup = translation.inverted().concatenating(rotation).concatenating(translation)
        return point.applying(transformGroup)
    }

    fileprivate func blowupAnimation(at point: CGPoint) -> CAAnimationGroup {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(cgPoint: point)]
        positionAnimation.keyTimes = [3]
 
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(3, 3, 1))
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(value: 0.0)
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
    
    fileprivate func shrinkAnimation(at point: CGPoint) -> CAAnimationGroup {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [NSValue(cgPoint: point)]
        positionAnimation.keyTimes = [3]
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1))

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = NSNumber(value: 0.0)
        
        let animationgroup = CAAnimationGroup()
        animationgroup.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        animationgroup.duration = CFTimeInterval(animationDuration)
        animationgroup.fillMode = kCAFillModeForwards
        
        return animationgroup
    }
}

extension PathMenu: PathMenuItemDelegate {
    public func touchesBegin(on item: PathMenuItem) {
        if item == startButton { handleTap() }
    }
    
    public func touchesEnd(on item: PathMenuItem) {
        if item == startButton { return }
        
        let blowup = blowupAnimation(at: item.center)
        item.layer.add(blowup, forKey: "blowup")
        item.center = item.startPoint
        
        for (_, menuItem) in menuItems.enumerated() {
            let otherItem = menuItem
            let shrink = shrinkAnimation(at: otherItem.center)
            
            if otherItem.tag == item.tag { continue }
            otherItem.layer.add(shrink, forKey: "shrink")
            otherItem.center = otherItem.startPoint
        }
        
        motionState = .close
        delegate?.willStartAnimationClose(on: self)
        
        let angle = motionState == .expand ? CGFloat(M_PI_4) + CGFloat(M_PI) : 0.0
        UIView.animate(withDuration: Double(startMenuAnimationDuration), animations: { [weak self] in
            self?.startButton?.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didFinishAnimationClose(on: strongSelf)
        })
        
        delegate?.didSelect(on: self, index: item.tag - 1000)
    }
}

extension PathMenu: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let animId = anim.value(forKey: "id") {
            if (animId as AnyObject).isEqual("lastAnimation") {
                delegate?.didFinishAnimationClose(on: self)
            }
            if (animId as AnyObject).isEqual("firstAnimation") {
                delegate?.didFinishAnimationOpen(on: self)
            }
        }
    }
}
