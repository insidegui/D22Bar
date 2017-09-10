//
//  D22MaskView.m
//  D22Bar
//
//  Created by Guilherme Rambo on 10/09/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "D22MaskView.h"

@import UIKit;

#define kCutoutHeight 30.0
#define kBottomCutoutRadius 20.0
#define kScreenRadius 20.0
#define kEarWidth 83.0
#define kNotchRegion 0.56

@implementation D22MaskView

- (UIImage *)notchMaskImage
{
    static UIImage *_mask;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        _mask = [UIImage imageNamed:@"notch" inBundle:bundle compatibleWithTraitCollection:nil];
    });
    
    return _mask;
}

- (UIImage *)verticalNotchMaskImage
{
    static UIImage *_mask;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        _mask = [UIImage imageNamed:@"notch-vert" inBundle:bundle compatibleWithTraitCollection:nil];
    });
    
    return _mask;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:kScreenRadius];
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    [[UIColor whiteColor] setFill];
    [maskPath fill];
    
    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) {
        [self drawHorizontalNotchInContext:ctx];
    } else {
        [self drawVerticalNotchInContext:ctx];
    }
}

- (void)drawHorizontalNotchInContext:(CGContextRef)ctx
{
    UIScreen *screen = [UIScreen mainScreen];
    UIImage *notch = [self notchMaskImage];
    
    CGFloat notchWidth = screen.bounds.size.width * kNotchRegion;
    CGSize notchSize = CGSizeMake(notchWidth, kCutoutHeight);
    CGRect notchRect = CGRectMake(screen.bounds.size.width / 2 - notchSize.width / 2, 0, notchSize.width, notchSize.height);
    
    [notch drawInRect:notchRect blendMode:kCGBlendModeNormal alpha:1];
    
    [self drawPatchInNotchRect:notchRect isVertical:NO];
}

- (void)drawVerticalNotchInContext:(CGContextRef)ctx
{
    UIScreen *screen = [UIScreen mainScreen];
    UIImage *notch = [self verticalNotchMaskImage];
    
    CGFloat notchHeight = screen.bounds.size.height * kNotchRegion;
    CGSize notchSize = CGSizeMake(kCutoutHeight, notchHeight);
    CGRect notchRect = CGRectMake(-1, screen.bounds.size.height / 2 - notchSize.height / 2, notchSize.width, notchSize.height);
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        CGContextScaleCTM(ctx, -1, 1);
        CGContextTranslateCTM(ctx, -screen.bounds.size.width, 0);
    }
    
    [notch drawInRect:notchRect blendMode:kCGBlendModeNormal alpha:1];
    
    [self drawPatchInNotchRect:notchRect isVertical:YES];
}

- (void)drawPatchInNotchRect:(CGRect)notchRect isVertical:(BOOL)vertical
{
    UIScreen *screen = [UIScreen mainScreen];
    
    CGFloat area = 0.75;
    
    CGFloat width = (vertical) ? notchRect.size.width : notchRect.size.width * area;
    CGFloat height = (vertical) ? notchRect.size.height * area : notchRect.size.height;
    
    CGFloat x = (vertical) ? notchRect.origin.x : screen.bounds.size.width * 0.5 - width * 0.5;
    CGFloat y = (vertical) ? screen.bounds.size.height * 0.5 - height * 0.5 : notchRect.origin.y;
    
    CGRect patchRect = CGRectMake(x, y, width, height);
    
    [[UIColor blackColor] setFill];
    UIRectFill(patchRect);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

@end
