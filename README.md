#PathMenu

Path 4.2 menu using CoreAnimation in Swift. Inspired by https://github.com/levey/AwesomeMenu

##Screenshot
![PathMenu-Sample](https://raw.githubusercontent.com/pixyzehn/PathMenu/master/Assets/PathMenu-Sample-Demo.gif)
![PathMenu](https://raw.githubusercontent.com/pixyzehn/PathMenu/master/Assets/PathMenu-Demo.gif)

##Installation

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

##How to use it?

Create the PathMenu by setting up the PathMenuItem.

For the details, please refer to PathMenu-Sample.

```Swift
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
```

And then, setup the PathMenu and some options.

```Swift
var menu: PathMenu = PathMenu(frame: self.window?.bounds, startItem: startItem, optionMenus: menus)
menu.delegate = self
self.window?.addSubview(menu)
self.window?.makeKeyAndVisible()
```

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
timeOffset = 0.036
rotateAngle = 0.0
menuWholeAngle = CGFloat(M_PI) * 2
expandRotation = -CGFloat(M_PI) * 2
closeRotation = CGFloat(M_PI) * 2
animationDuration = 0.5
expandRotateAnimationDuration = 2.0
closeRotateAnimationDuration = 1.0
startMenuAnimationDuration = 0.2
nearRadius = 110.0
endRadius = 120.0
farRadius = 140.0
```

##Delegate protocol (PathMenuDelegate)

```
optional func pathMenu(menu: PathMenu, didSelectIndex idx: Int)
optional func pathMenuDidFinishAnimationClose(menu: PathMenu)
optional func pathMenuDidFinishAnimationOpen(menu: PathMenu)
optional func pathMenuWillAnimateOpen(menu: PathMenu)
optional func pathMenuWillAnimateClose(menu: PathMenu)
```

## Licence

[MIT](https://github.com/pixyzehn/PathMenu/blob/master/LICENSE.txt)

## Author

[pixyzehn](https://github.com/pixyzehn)
