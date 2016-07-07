//
//  LocalVideoInfo.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalVideoInfo : NSObject

@property (nonatomic, copy) NSString*path;

@property (nonatomic, copy) NSString*name;

@property (nonatomic, assign) BOOL isDirectory;

@end
