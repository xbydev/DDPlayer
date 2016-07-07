//
//  NSBundle+NSBundleExtension.m
//  KanKanPlayer
//
//  Created by xunlei on 8/17/12.
//  Copyright (c) 2012 xunlei. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSBundle *)myResourcesBundle {
    static NSBundle* myResourceBundle = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        myResourceBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"KanKanPlayer" withExtension:@"bundle"]];
    });
    
    return myResourceBundle;
}

@end
