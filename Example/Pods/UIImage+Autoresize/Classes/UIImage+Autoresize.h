//
//  UIImage+Autoresize.h
//  UIImage+Autoresize
//
//  Created by kevin delord on 24/04/14.
//  Copyright (c) 2014 Kevin Delord. All rights reserved.
//

#ifndef UIImage_Autoresize_h__
#define UIImage_Autoresize_h__

#import <UIKit/UIKit.h>

/**
 * A categorized class of UIImage to add a naming convetion to deal with different image files:
 *
 * **none** if @1x small old phones
 * **@2x** for iPhone 4
 * **-568h@2x** for iPhone 5
 * **-667h@2x** for iPhone 6
 * **@3x** for iPhone 6 Plus
 */
@interface UIImage (Autoresize)

#pragma mark - UIImage Initializer

/**
 * Method to override the UIImage::imageNamed: method with the retina4ImageNamed: one.
 * The new method and its implementation will be executed instead of the default UIImage::imageNamed:
 * The user don't need to do anything.
 */
+ (void)load;

/**
 * Returns a new UIImage object created from a filename.
 *
 * @discussion If needed, this method will automatically add the needed image suffix for the current device:
 * - "@2x"
 * - "-568h@2x"
 * - "-667h@2x"
 * - "@3x"
 * Important: the given filename should NOT contain any size-extension, only a name and its file type.
 *
 * @param imageName The NSString object representing the filename of the image.
 * @return An UIImage created from a given string.
 */
+ (UIImage *)dynamicImageNamed:(NSString *)imageName;

@end

#endif