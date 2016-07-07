//
//  AlumVideoInfo.h
//  DDPlayer
//
//  Created by xiangbiying on 16/5/29.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlbumVideoInfo : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) long long size; //Bytes
@property(nonatomic, strong) NSNumber *duration;
@property(nonatomic, copy) NSString *format;
@property(nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSURL *videoURL;

@end
