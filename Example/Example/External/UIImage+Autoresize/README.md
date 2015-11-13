# UIImage+Autoresize

[![Version](https://img.shields.io/cocoapods/v/UIImage+Autoresize.svg?style=flat)](http://cocoadocs.org/docsets/UIImage+Autoresize)
[![License](https://img.shields.io/cocoapods/l/UIImage+Autoresize.svg?style=flat)](http://cocoadocs.org/docsets/UIImage+Autoresize)
[![Platform](https://img.shields.io/cocoapods/p/UIImage+Autoresize.svg?style=flat)](http://cocoadocs.org/docsets/UIImage+Autoresize)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The class is also available through this [Gist](https://gist.github.com/kevindelord/fe2e691d06ab745fbb00).

## Requirements

Through the categorised class `UIImage+Autoresize`, a naming convention is applied to deal with different image files.
The following suffixes are expected:

* **none** for 3GS and earlier
* **@2x** for iPhone 4, 4S
* **-568h@2x** for iPhone 5, 5C, 5S
* **-667h@2x** for iPhone 6
* **@3x** for iPhone 6 Plus
* **-512h** for iPad Mini, iPad 2, iPad 1
* **-1024h@2x** for iPad Mini 3, iPad Mini 2, iPad Air, iPad Air 2

When this class is integrated into your project, you have nothing else to do.
You can now instantiate an image in your code like this:

    [UIImage imageNamed: @"background.png" ];

The code will `automatically` load an image corresponding to the current device.

## Documentation

This pod is also documented on [CocoaDocs](http://cocoadocs.org/docsets/UIImage+Autoresize)

## Installation

UIImage+Autoresize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "UIImage+Autoresize"

## TODO:
* landscape logic
* Make it work with Storyboard

## Special thanks to
Dennis Rieth for the assets, dennis@ieth.de

## Author

kevindelord, delord.kevin@gmail.com

## License

UIImage+Autoresize is available under the MIT license. See the LICENSE file for more info.
