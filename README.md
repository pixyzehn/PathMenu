#PathMenu

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
![Swift3.0](https://img.shields.io/badge/Swift-3.0-blue.svg?style=flat)
[![Build Status](https://travis-ci.org/pixyzehn/PathMenu.svg?branch=master)](https://travis-ci.org/pixyzehn/PathMenu)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

Path 4.2 menu using CoreAnimation in Swift. Inspired by [AwesomeMenu](https://github.com/levey/AwesomeMenu).

##Screenshot
![PathMenu-Sample](https://raw.githubusercontent.com/pixyzehn/PathMenu/master/Assets/PathMenu-Sample-Demo.gif)
![PathMenu](https://raw.githubusercontent.com/pixyzehn/PathMenu/master/Assets/PathMenu-Demo.gif)

##Installation

###Cocoapods

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!
# The following is a Library of Swift.
pod 'PathMenu'
```

Then, run the following command:

```ruby
pod install
```

###Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PathMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "pixyzehn/PathMenu"
```

Run `carthage update`.  


```bash
$ carthage update
```

###Other

Add the PathMenu (including PathMenu.swift and PathMenuItem.swift) folder into your project.

---

##How to use it?

Create the PathMenu by setting up the PathMenuItem.

For the details, please refer to PathMenu-Sample.

```Swift
let menuItemImage = UIImage(named: "bg-menuitem")!
let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!

let starImage = UIImage(named: "icon-star")!

let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)

let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)

let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)

let starMenuItem4 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)

let starMenuItem5 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)

let items = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]

let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
                  highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
                      contentImage: UIImage(named: "icon-plus"),
           highlightedContentImage: UIImage(named: "icon-plus-highlighted"))

let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
menu.delegate = self
```

And then, setup the PathMenu and some options.

The following is the options about animation and position.

PathMenu-Sample project  is similar to real Path’s menu.

Quote from the PathMenu-Sample project.

```Swift
menu.startPoint = CGPointMake(UIScreen.mainScreen().bounds.width/2, self.view.frame.size.height - 30.0)
menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
menu.rotateAngle = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
menu.timeOffset = 0.0
menu.farRadius = 110.0
menu.nearRadius = 90.0
menu.endRadius = 100.0
menu.animationDuration = 0.5
```

The order is farRadius→nearRadius→endRadius.

Default values are as follows:

```Swift
startPoint = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
timeOffset                    = 0.036
rotateAngle                   = 0.0
menuWholeAngle                = CGFloat(M_PI * 2)
expandRotation                = -CGFloat(M_PI * 2)
closeRotation                 = CGFloat(M_PI * 2)
animationDuration             = 0.5
expandRotateAnimationDuration = 2.0
closeRotateAnimationDuration  = 1.0
startMenuAnimationDuration    = 0.2
nearRadius                    = 110.0
endRadius                     = 120.0
farRadius                     = 140.0
```

##Delegate protocol (PathMenuDelegate)

```
func didSelect(on menu: PathMenu, index: Int)
func didFinishAnimationClose(on menu: PathMenu)
func didFinishAnimationOpen(on menu: PathMenu)
func willStartAnimationOpen(on menu: PathMenu)
func willStartAnimationClose(on menu: PathMenu)
```

## Licence

[MIT](https://github.com/pixyzehn/PathMenu/blob/master/LICENSE.txt)

## Author

[pixyzehn](https://github.com/pixyzehn)
