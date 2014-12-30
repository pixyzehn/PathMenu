//
//  AppDelegate.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PathMenuDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
       
        let storyMenuItemImage: UIImage = UIImage(named: "bg-menuitem")!
        let storyMenuItemImagePressed: UIImage = UIImage(named: "bg-menuitem-highlighted")!
        
        let starImage: UIImage = UIImage(named: "icon-star")!
        
        let starMenuItem1: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem2: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        let starMenuItem3: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem4: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)
        
        let starMenuItem5: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        let starMenuItem6: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        let starMenuItem7: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        let starMenuItem8: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        let starMenuItem9: PathMenuItem = PathMenuItem(image: storyMenuItemImage, highlightedImage: storyMenuItemImagePressed, ContentImage: starImage, highlightedContentImage:nil)

        var menus: [PathMenuItem] = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7, starMenuItem8, starMenuItem9]
       
        let startItem: PathMenuItem = PathMenuItem(image: UIImage(named: "bg-addbutton"), highlightedImage: UIImage(named: "bg-addbutton-highlighted"), ContentImage: UIImage(named: "icon-plus"), highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        var menu: PathMenu = PathMenu(frame: self.window?.bounds, startItem: startItem, optionMenus: menus)
        menu.delegate = self
       
        self.window?.backgroundColor = UIColor(red:0.91, green:0.89, blue:0.87, alpha:1)
        self.window?.addSubview(menu)
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // PathMenuDelegate

    func pathMenu(menu: PathMenu, didSelectIndex idx: Int) {
        println("Select the index : \(idx)")
    }
    
    func pathMenuWillAnimateOpen(menu: PathMenu) {
        println("Menu will open!")
    }

    func pathMenuWillAnimateClose(menu: PathMenu) {
        println("Menu will close!")
    }
    
    func pathMenuDidFinishAnimationOpen(menu: PathMenu) {
        println("Menu was open!")
    }
    
    func pathMenuDidFinishAnimationClose(menu: PathMenu) {
        println("Menu was closed!")
    }
}

