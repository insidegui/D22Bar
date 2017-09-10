//
//  D22WindowSwizzler.m
//  D22Bar
//
//  Created by Guilherme Rambo on 10/09/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "D22WindowSwizzler.h"

#import <objc/runtime.h>

#import "D22MaskView.h"

@implementation D22WindowSwizzler

+ (void)load
{
    Method uikitOriginal = class_getInstanceMethod([UIWindow class], @selector(makeKeyAndVisible));
    Method override = class_getInstanceMethod([self class], @selector(__override_makeKeyAndVisible));
    
    IMP uikitImpl = method_getImplementation(uikitOriginal);
    const char *uikitTypes = method_getTypeEncoding(uikitOriginal);
    
    class_addMethod([UIWindow class], @selector(__original_makeKeyAndVisible), uikitImpl, uikitTypes);
    
    method_exchangeImplementations(uikitOriginal, override);
}

- (void)__override_makeKeyAndVisible
{
    [self __original_makeKeyAndVisible];
    
    D22MaskView *maskView = [[D22MaskView alloc] initWithFrame:self.bounds];
    [maskView setOpaque:NO];
    [maskView.layer setNeedsDisplayOnBoundsChange:YES];
    [maskView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:maskView];
    maskView.layer.zPosition = 9999999;
}

- (void)__original_makeKeyAndVisible
{
    return;
}

@end
