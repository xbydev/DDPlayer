//
//  LocalVideoManager.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "LocalVideoManager.h"
#import "LocalVideoInfo.h"

@implementation LocalVideoManager

+(instancetype)shareedLocalVideoManager{
    
    static LocalVideoManager *localVideoManager = nil;
    if (!localVideoManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            localVideoManager = [[LocalVideoManager alloc] init];
        });
    }
    return localVideoManager;
}

- (NSArray*)scanCurrentPath:(NSString*)dir{
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dir error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dir stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            LocalVideoInfo *localMovieInfo = [[LocalVideoInfo alloc] init];
            
            localMovieInfo.name = fileName;
            
            localMovieInfo.path = fullPath;
            
            localMovieInfo.isDirectory = flag;
            
            [array addObject:localMovieInfo];
        }
    }
    
    return array;
}

- (NSString*)getRootPath{
    
    // 获取程序Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

@end
