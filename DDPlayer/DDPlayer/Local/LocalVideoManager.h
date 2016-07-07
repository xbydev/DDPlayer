//
//  LocalVideoManager.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalVideoManager : NSObject

+(instancetype)shareedLocalVideoManager;

- (NSArray*)scanCurrentPath:(NSString*)dir;

- (NSString*)getRootPath;

@end
