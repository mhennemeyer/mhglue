//
//  UIImage+MHThumbnails.m
//
//  Copyright (c) 2013 Matthias Hennemeyer
//

#import "UIImage+MHThumbnails.h"

@implementation UIImage (MHThumbnails)
- (UIImage *) thumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newThumbnail;
}

@end
