//
//  UIImage+Autoresize.m
//  UIImage+Autoresize
//
//  Created by kevin delord on 24/04/14.
//  Copyright (c) 2014 Kevin Delord. All rights reserved.
//

#import "UIImage+Autoresize.h"
#import <objc/runtime.h>

#define __K_DEBUG_LOG_UIIMAGE_AUTORESIZE_ENABLED__      false

@implementation UIImage (Autoresize)

#pragma mark - UIImage Initializer

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method origImageNamedMethod = class_getClassMethod(self.class, @selector(imageNamed:));
        method_exchangeImplementations(origImageNamedMethod, class_getClassMethod(self.class, @selector(dynamicImageNamed:)));
    });
}

+ (NSString *)verticalExtensionForScale:(CGFloat)scale height:(CGFloat)h width:(CGFloat)w {

    if (__K_DEBUG_LOG_UIIMAGE_AUTORESIZE_ENABLED__) {
        NSLog(@"-------------------------------------");
        NSLog(@"h: %f", h);
        NSLog(@"w: %f", w);
        NSLog(@"scale: %f", scale);
        NSLog(@"-------------------------------------");
    }

    // generate the current valid file extension depending on the current device screen size.
    NSString *extension = @"";
    if (scale == 3.f) {
        extension = @"@3x";    // iPhone 6+
    } else if (scale == 2.f && h == 568.0f && w == 320.0f) {
        extension = @"-568h@2x";    // iPhone 5, 5S, 5C
    } else if (scale == 2.f && h == 667.0f && w == 375.0f) {
        extension = @"-667h@2x";    // iPhone 6
    } else if (scale == 2.f && h == 480.0f && w == 320.0f) {
        extension = @"@2x";         // iPhone 4, 4S
    } else if (scale == 1.f && h == 1024.0f && w == 768.0f) {
        extension = @"-512h";       // iPad Mini, iPad 2, iPad 1
    } else if (scale == 2.f && h == 1024.0f && w == 768.0f) {
        extension = @"-1024h@2x";   // iPad Mini 3, iPad Mini 2, iPad Air, iPad Air 2
    }
    return extension;
}

+ (UIImage *)dynamicImageNamed:(NSString *)imageName {

    // only change the name if no '@2x' or '@3x' are specified
    if ([imageName rangeOfString:@"@"].location == NSNotFound) {

        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat scale = [UIScreen mainScreen].scale;

        // generate the current valid file extension depending on the current device screen size.
        NSString *extension = [self verticalExtensionForScale:scale height:h width:w];

        // add the extension to the image name
        NSRange dot = [imageName rangeOfString:@"."];
        NSMutableString *imageNameMutable = [imageName mutableCopy];
        if (dot.location != NSNotFound)
            [imageNameMutable insertString:extension atIndex:dot.location];
        else
            [imageNameMutable appendString:extension];

        // if exist returns the corresponding UIImage
        if ([[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@""]) {
            return [UIImage dynamicImageNamed:imageNameMutable];
        }
    }
    // otherwise returns an UIImage with the original filename.
    return [UIImage dynamicImageNamed:imageName];
}

@end
