#PathMenu

Path 4.2 menu using CoreAnimation in Swift. Inspired by https://github.com/levey/AwesomeMenu

##Screenshot
![PathMenu](https://raw.githubusercontent.com/pixyzehn/PathMenu/master/Assets/PathMenu-Sample.gif)

##How to use it?
Copy & paste the PathMenu.swift and PathMenuItem,swift into your project.
Create the PathMenu by setting up the PathMenuItem:

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
quote from the PathMenu-Sample project.

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

##Delegate protocol (PathMenuDelegate)

```Swift
optional func pathMenu(menu: PathMenu, didSelectIndex idx: Int)
optional func pathMenuDidFinishAnimationClose(menu: PathMenu)
optional func pathMenuDidFinishAnimationOpen(menu: PathMenu)
optional func pathMenuWillAnimateOpen(menu: PathMenu)
optional func pathMenuWillAnimateClose(menu: PathMenu)
```

##LICENSE

PathMenu is available under the MIT license. See the LICENSE.txt file for more info.
