# Persei
[![Build Status](https://travis-ci.org/Yalantis/Persei.svg)](https://travis-ci.org/Yalantis/Persei)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Yalantis/Persei/blob/master/LICENSE)

![Preview](https://github.com/Yalantis/Persei/blob/master/Assets/animation.gif)

Animated top menu for UITableView / UICollectionView / UIScrollView written in Swift!

Made in [Yalantis](https://yalantis.com/?utm_source=github).

Check this [project on Dribbble](https://dribbble.com/shots/1706861-Top-Menu-Animation?list=users&offset=23)

Check this [project on Behance](https://www.behance.net/gallery/20411445/Mobile-Animations-Interactions%20)

## Supported Swift versions

| Swift Version | Persei |
|:---:|:---:|
| 1.x | 1.1 |
| 2.x | 2.0 |
| 3.x | 3.0 |
| **4.x** | **3.1** |

## Installation

### [CocoaPods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'Persei', '~> 3.0'
```

### [Carthage](http://github.com/Carthage/Carthage)

```ruby
github "Yalantis/Persei" ~> 3.0
```

### Manual Installation
> For application targets that do not support embedded frameworks, such as iOS 7, Persei can be integrated by including source files from the Persei folder directly, optionally wrapping the top-level types into `struct Persei` to simulate a namespace. Yes, this sucks.

1. Add Persei as a [submodule](http://git-scm.com/docs/git-submodule) by opening the Terminal, `cd`-ing into your top-level project directory, and entering the command `git submodule add https://github.com/yalantis/Persei.git`
2. Open the `Persei` folder, and drag `Persei.xcodeproj` into the file navigator of your app project.
3. In Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.
4. Ensure that the deployment target of `Persei.framework` matches that of the application target.
5. In the tab bar at the top of that window, open the "Build Phases" panel.
6. Expand the "Target Dependencies" group, and add `Persei.framework`.
7. Expand the "Link Binary With Libraries" group, and add `SideMenu.framework`
8. Click on the `+` button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `Persei.framework`.

## Usage
#### Import `Persei` module
```swift
import Persei
```

#### Init
```swift
let menu = MenuView()    
tableView.addSubview(menu)
```

#### Configuring items
In order to set items you need to instantiate array of `MenuItem`:

```swift
let items = feedModes.map { mode: SomeYourCustomFeedMode -> MenuItem in
	return MenuItem(image: mode.image)
}

menu.items = items
```

#### Handling selection
You can specify selected item manually:
```swift
menu.selectedIndex = 3
```

Note, that selectedIndex declared as `Int?` and will be `nil` in case of `menu.items = nil`.

Also, you can implement `MenuViewDelegate` to be notified about selection change:
```swift
// during init
menu.delegate = self

// actual implementation
extension FeedViewController: MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAt index: Int) {
    	dataSource.mode = feedModes[index] // alter mode of dataSource

    	tableView.reload() // update tableView
    }
}
```

#### Reveal menu manually
Menu can be reveal as a result of button tap:
```swift
func menuButtonSelected(sender: UIControl) {
	menu.revealed = !menu.revealed

	// or animated
	menu.setRevealed(true, animated: true)
}
```

#### Content Gravity
Use `contentViewGravity` to control sticking behavior. There are 3 available options:

- Top: `contentView` sticked to the top position of the view
- Center: `contentView` is aligned to the middle of the streched view
- Bottom: `contentView` sticked to the bottom

#### Customization
`MenuItem` declares set of attributes, that allow you to customize appearance of items:
```swift
struct MenuItem {
    var image: UIImage // default image
    var highlightedImage: UIImage? // image used during selection

    var backgroundColor: UIColor // default background color
    var highlightedBackgroundColor: UIColor // background color used during selection

    var shadowColor: UIColor // color of bottom 2px shadow line
}
```

Also you're free to configure background of `MenuView` by utilizing `backgroundColor` or `backgroundImage`. Note, that image should be resizeable:
```swift
let menu = MenuView()
menu.backgroundImage = UIImage(named: "top_menu_background")
```

#### Advanced customization
- Can I place the UIImageView instead?
- Sure! Just subclass / use `StickyHeaderView` directly. It offers layout, positioning and reveal control. All you have to do is to assign your custom view (animated nian-cat UIImageView) to `contentView`:

```swift
let headerView = StickyHeaderView()
let imageView = UIImageView(...)

headerView.contentView = imageView
```

Obviously, your custom view can have heigh different from default:
```swift
headerView.contentHeight = image.size.height
```

As well as control distance to trigger open/close of the header:
```swift
headerView.threshold = 0.5
```
Threshold is a float value from 0 to 1, specifies how much user needs to drag header for reveal.

#### Let us know!

We’d be really happy if you sent us links to your projects where you use our component. Just send an email to github@yalantis.com And do let us know if you have any questions or suggestion regarding the animation.

P.S. We’re going to publish more awesomeness wrapped in code and a tutorial on how to make UI for iOS (Android) better than better. Stay tuned!

## License

	The MIT License (MIT)

	Copyright © 2017 Yalantis

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
