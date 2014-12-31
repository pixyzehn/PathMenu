//
//  ViewController.swift
//  PathMenu-Sample
//
//  Created by pixyzehn on 12/31/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PathMenuDelegate {
    
    var blackView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let storyMenuItemImage: UIImage = UIImage(named: "bg-menuitem")!
        let storyMenuItemImagePressed: UIImage = UIImage(named: "bg-menuitem-highlighted")!
        
        let starImage: UIImage = UIImage(named: "icon-star")!
        
        let starMenuItem1: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem2: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem3: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem4: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem5: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        var menus: [PathMenuItem] = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]
        
        let startItem: PathMenuItem = PathMenuItem(image: UIImage(named: "bg-addbutton"), highlightedImage: UIImage(named: "bg-addbutton-highlighted"), ContentImage: UIImage(named: "icon-plus"), highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        var menu: PathMenu = PathMenu(frame: self.view.bounds, startItem: startItem, optionMenus: menus)
        menu.delegate = self
        menu.startPoint = CGPointMake(UIScreen.mainScreen().bounds.width/2, self.view.frame.size.height - 30.0)
        menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
        menu.rotateAngle = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
        menu.timeOffset = 0.0
        menu.farRadius = 110.0
        menu.nearRadius = 90.0
        menu.endRadius = 100.0
        menu.animationDuration = 0.5
        
        self.blackView = UIView(frame: UIScreen.mainScreen().bounds)
        self.blackView?.addSubview(menu)
        self.blackView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.blackView!)
        self.view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.92, alpha:1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // PathMenuDelegate
    
    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        println("Select the index : \(idx)")
        self.blackView?.backgroundColor = UIColor.clearColor()
    }
    
    func pathMenuWillAnimateOpen(menu: PathMenu) {
        println("Menu will open!")
        self.blackView?.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.7)
    }
    
    func pathMenuWillAnimateClose(menu: PathMenu) {
        println("Menu will close!")
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
        println("Menu was open!")
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
        println("Menu was closed!")
        self.blackView?.backgroundColor = UIColor.clearColor()
    }
}

