//
//  D22Swizzler.m
//  D22Bar
//
//  Created by Guilherme Rambo on 10/09/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "D22Swizzler.h"

#import <objc/runtime.h>

@implementation D22Swizzler

+ (void)load
{
    Class statusBarBaseClass = NSClassFromString(@"UIStatusBar_Base");
    
    if (!statusBarBaseClass) {
        #if DEBUG
        NSLog(@"UIStatusBar_Base is not available.");
        #endif
        
        return;
    }
    
    Class statusBarClass = NSClassFromString(@"_UIStatusBar");
    
    if (!statusBarClass) {
        #if DEBUG
        NSLog(@"_UIStatusBar is not available.");
        #endif
        
        return;
    }
    
    Method m5 = class_getClassMethod(statusBarBaseClass, NSSelectorFromString(@"_statusBarImplementationClass"));
    
    if (!m5) {
        #if DEBUG
        NSLog(@"Unable to find method _statusBarImplementationClass");
        #endif
        
        return;
    }
    
    Method m6 = class_getClassMethod([D22Swizzler class], NSSelectorFromString(@"__d22swizzler__statusBarImplementationClass"));
    method_exchangeImplementations(m5, m6);
    
    Method m7 = class_getClassMethod(NSClassFromString(@"_UIStatusBar"), NSSelectorFromString(@"forceSplit"));
    
    if (!m7) {
        #if DEBUG
        NSLog(@"Unable to find method forceSplit");
        #endif
        
        return;
    }
    
    Method m8 = class_getClassMethod([D22Swizzler class], @selector(__d22swizzler_forceSplit));
    method_exchangeImplementations(m7, m8);
}

+ (Class)__d22swizzler__statusBarImplementationClass
{
    return NSClassFromString(@"UIStatusBar_Modern");
}

+ (BOOL)__d22swizzler_forceSplit
{
    return YES;
}

@end
