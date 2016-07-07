//
//  KxAudioManager.m
//  DDPlayer
//
//  Created by xiangbiying on 16/4/1.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import "KxAudioManager.h"
#import "TargetConditionals.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h> //Accelerate这个framework主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。我们可以认为我们的图像都是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，自然就能方便我们对图像做各种各样的处理。
#import "KxLogger.h"
#import <AVFoundation/AVFoundation.h>

#define MAX_FRAME_SIZE 4096
#define MAX_CHAN       2

#define MAX_SAMPLE_DUMPED 5

static BOOL checkError(OSStatus error, const char *operation);
//static void sessionPropertyListener(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData);
//static void sessionInterruptionListener(void *inClientData, UInt32 inInterruption);
static OSStatus renderCallback (void *inRefCon, AudioUnitRenderActionFlags	*ioActionFlags, const AudioTimeStamp * inTimeStamp, UInt32 inOutputBusNumber, UInt32 inNumberFrames, AudioBufferList* ioData);

@interface KxAudioManagerImpl : KxAudioManager<KxAudioManager> {
    
    BOOL                        _initialized;
    BOOL                        _activated;
    float                       *_outData;
    AudioUnit                   _audioUnit;
    AudioStreamBasicDescription _outputFormat;
}

@property (readonly) NSInteger             numOutputChannels;
@property (readonly) double            samplingRate;
@property (readonly) UInt32             numBytesPerSample;
@property (readwrite) float           outputVolume;
@property (readonly) BOOL               playing;
@property (readonly, strong) NSString   *audioRoute;

@property (readwrite, copy) KxAudioManagerOutputBlock outputBlock;
@property (readwrite) BOOL playAfterSessionEndInterruption;

- (BOOL) activateAudioSession;
- (void) deactivateAudioSession;
- (BOOL) play;
- (void) pause;

- (BOOL) checkAudioRoute;
- (BOOL) setupAudio;
- (BOOL) checkSessionProperties;
- (BOOL) renderFrames: (UInt32) numFrames
               ioData: (AudioBufferList *) ioData;

@end

@implementation KxAudioManagerImpl

- (id)init{
    
    self = [super init];
    if (self) {
        _outData = (float *)calloc(MAX_FRAME_SIZE*MAX_CHAN, sizeof(float));
        _outputVolume = 0.5;
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
    
    if (_outData) {
        
        free(_outData);
        _outData = NULL;
    }
}

#pragma mark - private

// Debug: dump the current frame data. Limited to 20 samples.

#define dumpAudioSamples(prefix, dataBuffer, samplePrintFormat, sampleCount, channelCount) \
{ \
    NSMutableString *dump = [NSMutableString stringWithFormat:prefix]; \
    for (int i = 0; i < MIN(MAX_SAMPLE_DUMPED, sampleCount); i++) \
    { \
        for (int j = 0; j < channelCount; j++) \
        { \
            [dump appendFormat:samplePrintFormat, dataBuffer[j + i * channelCount]]; \
        } \
        [dump appendFormat:@"\n"]; \
    } \
    LoggerAudio(3, @"%@", dump); \
}

#define dumpAudioSamplesNonInterleaved(prefix, dataBuffer, samplePrintFormat, sampleCount, channelCount) \
{ \
    NSMutableString *dump = [NSMutableString stringWithFormat:prefix]; \
    for (int i = 0; i < MIN(MAX_SAMPLE_DUMPED, sampleCount); i++) \
    { \
        for (int j = 0; j < channelCount; j++) \
        { \
            [dump appendFormat:samplePrintFormat, dataBuffer[j][i]]; \
        } \
    [dump appendFormat:@"\n"]; \
    } \
    LoggerAudio(3, @"%@", dump); \
}

- (BOOL) checkAudioRoute
{
    // Check what the audio route is.
//    UInt32 propertySize = sizeof(CFStringRef);
//    CFStringRef route;
    
    AVAudioSessionRouteDescription * routDes = [[AVAudioSession sharedInstance] currentRoute];
    NSLog(@"the routDes is %@",routDes);
    if (routDes.outputs.count == 0) {
        
        return NO;
    }else{
        
        AVAudioSessionPortDescription *portDes = routDes.outputs[0];
        NSLog(@"the portDes.type is %@",portDes.portType);
        NSLog(@"the portDes.portName is %@",portDes.portName);
    }
    
    return YES;
}

- (BOOL)setupAudio{

    NSError *nsError;
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayback error:&nsError];
    
    if( nsError != nil ){
        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChangeNoti:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    //音量变化用KVO来做。
    _outputVolume = [AVAudioSession sharedInstance].outputVolume;
    
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    
#if !TARGET_IPHONE_SIMULATOR
    
    Float32 preferredBufferSize = 0.0232;//0.005
    NSError* error;
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:preferredBufferSize error:&error];
    
    if (error) {
        return NO;
    }
#endif
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) {
         return NO;
    }
    
    [self checkSessionProperties];
    
    AudioComponentDescription description = {0};
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_RemoteIO;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // Get component
    AudioComponent component = AudioComponentFindNext(NULL, &description);
    if (checkError(AudioComponentInstanceNew(component, &_audioUnit),
                   "Couldn't create the output audio unit"))
        return NO;
    
    UInt32 size;
    
    // Check the output stream format
    size = sizeof(AudioStreamBasicDescription);
    if (checkError(AudioUnitGetProperty(_audioUnit,
                                        kAudioUnitProperty_StreamFormat,
                                        kAudioUnitScope_Input,
                                        0,
                                        &_outputFormat,
                                        &size),
                   "Couldn't get the hardware output stream format"))
        return NO;
    
    
    _outputFormat.mSampleRate = _samplingRate;
    if (checkError(AudioUnitSetProperty(_audioUnit,
                                        kAudioUnitProperty_StreamFormat,
                                        kAudioUnitScope_Input,
                                        0,
                                        &_outputFormat,
                                        size),
                   "Couldn't set the hardware output stream format")) {
        
        // just warning
    }
    
    _numBytesPerSample = _outputFormat.mBitsPerChannel / 8;
    _numOutputChannels = _outputFormat.mChannelsPerFrame;
    
    LoggerAudio(2, @"Current output bytes per sample: %u", (unsigned int)_numBytesPerSample);
    LoggerAudio(2, @"Current output num channels: %u", (unsigned int)_numOutputChannels);
    
    // Slap a render callback on the unit
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = renderCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)(self);
    
    if (checkError(AudioUnitSetProperty(_audioUnit,
                                        kAudioUnitProperty_SetRenderCallback,
                                        kAudioUnitScope_Input,
                                        0,
                                        &callbackStruct,
                                        sizeof(callbackStruct)),
                   "Couldn't set the render callback on the audio unit"))
        return NO;
    
    if (checkError(AudioUnitInitialize(_audioUnit),
                   "Couldn't initialize the audio unit"))
        return NO;
    
    return YES;
}

- (BOOL) checkSessionProperties
{
    [self checkAudioRoute];
    
    NSInteger newNumChannels = [AVAudioSession sharedInstance].outputNumberOfChannels;
    
     LoggerAudio(2, @"We've got %lu output channels", newNumChannels);
    
    _samplingRate = [AVAudioSession sharedInstance].sampleRate;
    
    LoggerAudio(2, @"Current sampling rate: %f", _samplingRate);
    
    _outputVolume = [AVAudioSession sharedInstance].outputVolume;
    
    LoggerAudio(1, @"Current output volume: %f", _outputVolume);
    
    return YES;
}

- (void)handleRouteChangeNoti:(NSNotification *)notification{
    
    
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context{
    
    if ([keyPath isEqual:@"outputVolume"]) {
        
        _outputVolume = [AVAudioSession sharedInstance].outputVolume;
    }
}

//矩阵运算的几个地方没有看懂
- (BOOL) renderFrames: (UInt32) numFrames
               ioData: (AudioBufferList *) ioData
{
    for (int iBuffer=0; iBuffer < ioData->mNumberBuffers; ++iBuffer) {
        memset(ioData->mBuffers[iBuffer].mData, 0, ioData->mBuffers[iBuffer].mDataByteSize);
    }
    
    if (_playing && _outputBlock ) {
        
        // Collect data to render from the callbacks
        _outputBlock(_outData, numFrames, _numOutputChannels);
        
        // Put the rendered data into the output buffer
        if (_numBytesPerSample == 4) // then we've already got floats
        {
            float zero = 0.0;
            
            for (int iBuffer=0; iBuffer < ioData->mNumberBuffers; ++iBuffer) {
                
                int thisNumChannels = ioData->mBuffers[iBuffer].mNumberChannels;
                
                for (int iChannel = 0; iChannel < thisNumChannels; ++iChannel) {
                    vDSP_vsadd(_outData+iChannel, _numOutputChannels, &zero, (float *)ioData->mBuffers[iBuffer].mData, thisNumChannels, numFrames);
                }
            }
        }
        else if (_numBytesPerSample == 2) // then we need to convert SInt16 -> Float (and also scale)
        {
            //            dumpAudioSamples(@"Audio frames decoded by FFmpeg:\n",
            //                             _outData, @"% 12.4f ", numFrames, _numOutputChannels);
            
            float scale = (float)INT16_MAX;
            vDSP_vsmul(_outData, 1, &scale, _outData, 1, numFrames*_numOutputChannels);
            
#ifdef DUMP_AUDIO_DATA
            LoggerAudio(2, @"Buffer %u - Output Channels %u - Samples %u",
                        (uint)ioData->mNumberBuffers, (uint)ioData->mBuffers[0].mNumberChannels, (uint)numFrames);
#endif
            
            for (int iBuffer=0; iBuffer < ioData->mNumberBuffers; ++iBuffer) {
                
                int thisNumChannels = ioData->mBuffers[iBuffer].mNumberChannels;
                
                for (int iChannel = 0; iChannel < thisNumChannels; ++iChannel) {
                    vDSP_vfix16(_outData+iChannel, _numOutputChannels, (SInt16 *)ioData->mBuffers[iBuffer].mData+iChannel, thisNumChannels, numFrames);
                }
#ifdef DUMP_AUDIO_DATA
                dumpAudioSamples(@"Audio frames decoded by FFmpeg and reformatted:\n",
                                 ((SInt16 *)ioData->mBuffers[iBuffer].mData),
                                 @"% 8d ", numFrames, thisNumChannels);
#endif
            }
            
        }        
    }
    
    return noErr;
}

#pragma mark - public

- (BOOL) activateAudioSession
{
    if (!_activated) {
        
        if (!_initialized) {
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeInterruptionType:)
                                                         name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
            _initialized = YES;
        }
        
        if ([self checkAudioRoute] &&
            [self setupAudio]) {
            
            _activated = YES;
        }
    }
    
    return _activated;
}

- (void)audioSessionDidChangeInterruptionType:(NSNotification *)notification
{
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo]
                                                        objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (AVAudioSessionInterruptionTypeBegan == interruptionType){
        
        self.playAfterSessionEndInterruption = self.playing;
        
        [self pause];
        
    }else if (AVAudioSessionInterruptionTypeEnded == interruptionType){
        
        if (self.playAfterSessionEndInterruption) {
            
            self.playAfterSessionEndInterruption = NO;
            
            [self play];
        }
    }
}

- (void) deactivateAudioSession
{
    if (_activated) {
        
        [self pause];
        
        checkError(AudioUnitUninitialize(_audioUnit),
                   "Couldn't uninitialize the audio unit");
        
        checkError(AudioComponentInstanceDispose(_audioUnit),
                   "Couldn't dispose the output audio unit");
        
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
        
        [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
        
        _activated = NO;
    }
}

- (void) pause{
    
    if (_playing) {
        
        _playing = checkError(AudioOutputUnitStop(_audioUnit),
                              "Couldn't stop the output unit");
    }
}

- (BOOL) play
{
    if (!_playing) {
        
        if ([self activateAudioSession]) {
            
            _playing = !checkError(AudioOutputUnitStart(_audioUnit),
                                   "Couldn't start the output unit");
        }
    }
    
    return _playing;
}

@end

@implementation KxAudioManager

+ (id<KxAudioManager>) audioManager
{
    static KxAudioManagerImpl *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[KxAudioManagerImpl alloc] init];
    });
    return audioManager;
}

@end

static OSStatus renderCallback (void						*inRefCon,
                                AudioUnitRenderActionFlags	* ioActionFlags,
                                const AudioTimeStamp 		* inTimeStamp,
                                UInt32						inOutputBusNumber,
                                UInt32						inNumberFrames,
                                AudioBufferList				* ioData)
{
    KxAudioManagerImpl *sm = (__bridge KxAudioManagerImpl *)inRefCon;
    return [sm renderFrames:inNumberFrames ioData:ioData];
}

static BOOL checkError(OSStatus error, const char *operation)
{
    if (error == noErr)
        return NO;
    
    char str[20] = {0};
    // see if it appears to be a 4-char-code
    *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(error);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\'';
        str[6] = '\0';
    } else
        // no, format it as an integer
        sprintf(str, "%d", (int)error);
    
    LoggerStream(0, @"Error: %s (%s)\n", operation, str);
    
    //exit(1);
    
    return YES;
}




