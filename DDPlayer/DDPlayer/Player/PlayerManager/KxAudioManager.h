//
//  KxAudioManager.h
//  DDPlayer
//
//  Created by xiangbiying on 16/4/1.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KxAudioManagerOutputBlock)(float *data, UInt32 numFrames, NSInteger numChannels);

@protocol KxAudioManager <NSObject>

@property (readonly) NSInteger   numOutputChannels;
@property (readonly) double  samplingRate;
@property (readonly) UInt32   numBytesPerSample;
@property (readonly) float  outputVolume;
@property (readonly) BOOL     playing;
@property (readonly, strong) NSString   *audioRoute;

@property (readwrite, copy) KxAudioManagerOutputBlock outputBlock;

- (BOOL) activateAudioSession;
- (void) deactivateAudioSession;
- (BOOL) play;
- (void) pause;

@end

@interface KxAudioManager : NSObject

+ (id<KxAudioManager>) audioManager;

@end
