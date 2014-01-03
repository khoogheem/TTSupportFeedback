//
//  UIImage+Utils.m
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

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

//When image cacheing is not needed. bydefault [uiimage imagenamed] caches into memory..
+ (UIImage *)imageFromBundle:(NSString *)imageName {
	NSRange r = [imageName rangeOfString:@"."];
    NSString *fileName = imageName;
    NSString *fileType = @"png"; //default
    if (r.location != NSNotFound) {
        fileName = [imageName substringToIndex:r.location];
        fileType = [imageName substringFromIndex:(r.location + 1)];
    }
    CGFloat scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        scale = screen.scale;
    }
    if (scale == 2.0) {
        fileName = [fileName stringByAppendingString:@"@2x"];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (UIImage *)menuImage{
    return [UIImage menuImage:[UIColor whiteColor]];
}

+ (UIImage *)menuImage:(UIColor *)color{
    
    static UIImage *defaultLeftBackImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 2, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 0, 18, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 2, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 5, 12, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 2, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 10, 18, 1)] fill];
		
		[[UIColor purpleColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 2, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 1, 18, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  2, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 6,  12, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 2, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(4, 11, 18, 2)] fill];
				
		defaultLeftBackImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
	});
    return defaultLeftBackImage;
}

+(UIImage*)drawImageOfSize:(CGSize)size andColor:(UIColor*)color{
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)image:(UIImage *)sourceImage scaleAndCroppForSize:(CGSize)targetSize {
	
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor >= heightFactor) {
			scaleFactor = widthFactor; // scale to fit height
        } else {
			scaleFactor = heightFactor; // scale to fit width
		}
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor >= heightFactor)	{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor < heightFactor)	{
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	UIGraphicsBeginImageContext(targetSize); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	if(newImage == nil)
        NSLog(@"could not scale image");
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)scaleAndCropToSize:(CGSize)targetSize {
	return [UIImage image:self scaleAndCroppForSize:(CGSize)targetSize];
}

- (UIImage *)scaleAndCropToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded {
	
	UIImage *image;
	
	if (!onlyIfNeeded || [self needsToScale:targetSize]) {
		image = [self scaleAndCropToSize:targetSize];
	} else {
		image = self;
	}
	
	return image;
}

+ (UIImage *)image:(UIImage *)sourceImage scaleToSize:(CGSize)targetSize {
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetSize.width;
	CGFloat scaledHeight = targetSize.height;
	
	CGFloat widthFactor = targetSize.width / sourceImage.size.width;
	CGFloat heightFactor = targetSize.height / sourceImage.size.height;
	
	if (widthFactor < heightFactor) {
		scaleFactor = widthFactor; // scale to fit height
	} else {
		scaleFactor = heightFactor; // scale to fit width
	}
	
	scaledWidth  = sourceImage.size.width * scaleFactor;
	scaledHeight = sourceImage.size.height * scaleFactor;
	
	CGSize propperSize = CGSizeMake(scaledWidth, scaledHeight);
	
	UIGraphicsBeginImageContext( propperSize );
	[sourceImage drawInRect:CGRectMake(0, 0, propperSize.width, propperSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)scaleToSize:(CGSize)newSize {
	return [UIImage image:self scaleToSize:newSize];
}

- (UIImage *)scaleToSize:(CGSize)targetSize onlyIfNeeded:(BOOL)onlyIfNeeded {
	
	UIImage *image;
	
	if (!onlyIfNeeded || [self needsToScale:targetSize]) {
		image = [self scaleToSize:targetSize];
	} else {
		image = self;
	}
	
	return image;
}

+ (BOOL)image:(UIImage *)sourceImage needsToScale:(CGSize)targetSize {
	BOOL needsToScale = NO;
	
	if (sourceImage.size.width > targetSize.width) {
		needsToScale = YES;
	}
	
	if (sourceImage.size.height > targetSize.height) {
		needsToScale = YES;
	}
	
	return needsToScale;
}

- (BOOL)needsToScale:(CGSize)targetSize {
	return [UIImage image:self needsToScale:targetSize];
}


+ (UIImage *)overlayImage:(UIImage *)overlayImage orgImage:(UIImage *)orgImage atPoint:(CGPoint)point
{
	UIGraphicsBeginImageContextWithOptions(orgImage.size, FALSE, 0.0);
    [orgImage drawInRect:CGRectMake( 0, 0, orgImage.size.width, orgImage.size.height)];
    [overlayImage drawInRect:CGRectMake( point.x, point.y, overlayImage.size.width, overlayImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImage;
    
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)negativeImage
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = self.size;
    int width = size.width;
    int height = size.height;
	
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
	
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
		
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;
			
            // perform the colour inversion
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
			
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
	
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
	
    // and return
    return returnImage;
}

+ (UIImage *)image:(UIImage *)sourceImage tintWithColor:(UIColor *)color {
	
	// lets tint the icon - assumes your icons are black
    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextTranslateCTM(context, 0, sourceImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
	
    CGRect rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
	
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, sourceImage.CGImage);
	
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
	
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return coloredImage;
}

+ (CGImageRef)gradientMask
{
    static CGImageRef sharedMask = NULL;
    if (sharedMask == NULL)
    {
        //create gradient mask
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 256), YES, 0.0);
        CGContextRef gradientContext = UIGraphicsGetCurrentContext();
        CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        CGPoint gradientStartPoint = CGPointMake(0, 0);
        CGPoint gradientEndPoint = CGPointMake(0, 256);
        CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                    gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        sharedMask = CGBitmapContextCreateImage(gradientContext);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }
    return sharedMask;
}

- (UIImage *)reflectedImageWithScale:(CGFloat)scale
{
	//get reflection dimensions
	CGFloat height = ceil(self.size.height * scale);
	CGSize size = CGSizeMake(self.size.width, height);
	CGRect bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
	
	//create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//clip to gradient
	CGContextClipToMask(context, bounds, [[self class] gradientMask]);
	
	//draw reflected image
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0.0f, -self.size.height);
	[self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
	
	//capture resultant image
	UIImage *reflection = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return reflection image
	return reflection;
}

- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha
{
    //get reflected image
    UIImage *reflection = [self reflectedImageWithScale:scale];
    CGFloat reflectionOffset = reflection.size.height + gap;
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height + reflectionOffset * 2.0f), NO, 0.0f);
    
    //draw reflection
    [reflection drawAtPoint:CGPointMake(0.0f, reflectionOffset + self.size.height + gap) blendMode:kCGBlendModeNormal alpha:alpha];
    
    //draw image
    [self drawAtPoint:CGPointMake(0.0f, reflectionOffset)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur
{
    //get size
    CGSize border = CGSizeMake(fabsf(offset.width) + blur, fabsf(offset.height) + blur);
    CGSize size = CGSizeMake(self.size.width + border.width * 2.0f, self.size.height + border.height * 2.0f);
    
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set up shadow
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
    
    //draw with shadow
    [self drawAtPoint:CGPointMake(border.width, border.height)];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    //draw with alpha
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return image
	return image;
}

- (UIImage *)imageWithMask:(UIImage *)maskImage;
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply mask
    CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), maskImage.CGImage);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}
@end
