//
//  UIImage+Utils.h
//
//  Created by Kevin A. Hoogheem on 12/15/13.
//  Copyright (c) 2013. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

//Image does not chache like UIImage imageNamed
+ (UIImage *)imageFromBundle:(NSString *)imageName;

+ (UIImage *)menuImage;
+ (UIImage *)menuImage:(UIColor *)color;

+ (UIImage*)drawImageOfSize:(CGSize)size andColor:(UIColor*)color;

+ (UIImage *)image:(UIImage *)sourceImage scaleAndCroppForSize:(CGSize)targetSize;
- (UIImage *)scaleAndCropToSize:(CGSize)newSize;
- (UIImage *)scaleAndCropToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded;

+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)newSize;
- (UIImage *)scaleToSize:(CGSize)newSize;
- (UIImage *)scaleToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded;

+ (BOOL)image:(UIImage *)sourceImage needsToScale:(CGSize)targetSize;
- (BOOL)needsToScale:(CGSize)targetSize;

+ (UIImage *)overlayImage:(UIImage *)overlayImage orgImage:(UIImage *)orgImage atPoint:(CGPoint)point;

+ (UIImage *)imageFromColor:(UIColor *)color;

- (UIImage *)negativeImage;

+ (UIImage *)image:(UIImage *)image tintWithColor:(UIColor *)color;


- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;



@end
