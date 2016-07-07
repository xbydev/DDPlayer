//
//  PlayerViewController.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/23.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "PlayerViewController.h"
//#import "PlayerAdapter.h"
#import "DDPlayerGLRenderView.h"

@interface PlayerViewController ()<KanKanSliderDelegate>
{
    //this is a C++ object
//    DDPlayerAdapter*    m_pPlayerAdapter;
    
    //this is a oc object
    DDPlayerGLRenderView*     _playerVideoRender;
    DDPlayerGLRenderView*  _playerSubtitleRender;
    
    NSTimer*    _updateProgressTimer;
    
    //just for back up
    //    MovieSeenedObject* _movieSeenedObject;
    float _movieSeenedPercent;
    
    int64_t _movieTotalDuration;
    
    NSString* _strMovieTotalDuration;
}
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    m_pPlayerAdapter = new DDPlayerAdapter(self);
    
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    CGRect rectDisplay = CGRectMake(rectScreen.origin.x,
                                    rectScreen.origin.y,
                                    rectScreen.size.height,
                                    rectScreen.size.width);
    _playerVideoRender = [[DDPlayerGLRenderView alloc] initWithFrame:rectDisplay];
    _playerVideoRender.backgroundColor = [UIColor clearColor];
    //add the render view to the object
    [self.view addSubview:_playerVideoRender];
    
//    _playerSubtitleRender = [[DDPlayerGLRenderView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
//    _playerSubtitleRender.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_playerSubtitleRender];
    
    NSString* medaiPath = [NSString stringWithFormat:@"%@%@", self.mediaPath, self.mediaName];
    _titleLabel.text = self.mediaName;
    
//    m_pPlayerAdapter->SetRenderSize(rectScreen.size.height, rectScreen.size.width);
//    m_pPlayerAdapter->Open(medaiPath);
    
//    NSString* urlSubtitle = [NSString stringWithFormat:@"%@%@", self.mediaPath, @"test.ass"];
//    [self pushOutSubtitle:urlSubtitle];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //this is a C++ object
//    delete m_pPlayerAdapter;
    
    //this is a oc object
    _playerVideoRender = nil;
    _playerSubtitleRender = nil;
    
    [_updateProgressTimer invalidate];
    _updateProgressTimer = nil;
    
    _strMovieTotalDuration = nil;
}

- (void)initProgressSlider{
    
    UIImage* imageTrackBg = [UIImage imageNamed:@"slider_gray"];
    UIImage* imageBufferBg = [UIImage imageNamed:@"slider_blue"];
    UIImage* imageThumbNormal = [UIImage imageNamed:@"slider_thumb_normal"];
    UIImage* imageThumbHighlighted = [UIImage imageNamed:@"slider_thumb_high"];
    UIImage* imageThumbDisable = [UIImage imageNamed:@"slider_thumb_normal"];
    _progressSlider.imageTrackBg = imageTrackBg;
    _progressSlider.imageBufferBg = imageBufferBg;
    _progressSlider.imageThumbNormal = imageThumbNormal;
    _progressSlider.imageThumbHighlighted = imageThumbHighlighted;
    _progressSlider.imageThumbDisable = imageThumbDisable;
    _progressSlider.delegate = self;
    _progressSlider.minimumValue = 0;
//    _progressSlider.maximumValue = _duration;
//    _progressSlider.value = _availableDuration;
}

#pragma mark - Utils
-(NSString*)formatTime:(int64_t)time{

    NSMutableString* strResult = [[NSMutableString alloc] init];
    
    int64_t divide = 60 * 60;
    
    while (divide)
    {
        int64_t numb = time / divide;
        
        NSString* strNumb = [NSString stringWithFormat:@"%02lld", numb];
        [strResult appendString:strNumb];
        
        if (divide > 1)
        {
            [strResult appendString:@":"];
        }
        
        time %= divide;
        divide /= 60;
    }
    
    return strResult;
}

#pragma mark - PlayerDelegate
- (int)connectGLContext:(int)rId{

//    if ((DDPlayer::RENDER_FRAME_ID)rId == DDPlayer::RENDER_FRAME_ID_VIDEO)
//    {
//        return [_playerVideoRender connectGLContext];
//    }else if((DDPlayer::RENDER_FRAME_ID)rId == DDPlayer::RENDER_FRAME_ID_SUBTITLE)
//    {
//        return [_playerSubtitleRender connectGLContext];
//    }
    return -1;
}

- (int)postDrawFrame:(int)rId{

    return 0;
}

- (int)renderSubtitle:(const uint8_t*)pDataBuffer dataSize:(int)dataSize with:(int)width height:(int)height picture:(int)picture{

    return 0;
}

//call the run the function in the main thread
- (void)onCommandOpen:(NSArray*)errCode{

    if ([[errCode objectAtIndex:0] intValue] != 0)
    {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"错误"
                                                           message:@"打开文件失败"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    
    if (fabsf(_movieSeenedPercent - 0.0f) > 0.01)
    {
        //m_pPlayerAdapter->Seek(_movieSeenedPercent);
    }
    
//    _movieTotalDuration = m_pPlayerAdapter->GetTotalDuration();
    
    
    _strMovieTotalDuration = [self formatTime:_movieTotalDuration];
    
    float defaultVolume = 0.5f;
    
//    m_pPlayerAdapter->SetVolume(defaultVolume);
    
    _volumeSlider.value = defaultVolume;
    
    _updateProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    //Start the time
    [_updateProgressTimer fire];
    
//    m_pPlayerAdapter->Play();
}

- (void)onCommandStop:(NSArray*)errCode{
    
}

- (void)updateProgress:(id)userInfo
{
//    int64_t currentPosition = m_pPlayerAdapter->GetCurrentPosition();
//    
//    float posPercent = (double)currentPosition / _movieTotalDuration;
//    
//    _progressSlider.value = posPercent;
    
//    [_footerViewController setProgressSliderPostion:posPercent];
//    
//    g_backupSecondCount ++;
//    if (g_backupSecondCount == 9)
//    {
//        MovieSeenedObject* movieSeenedObject = [[MovieSeenedObject alloc] init];
//        movieSeenedObject.filePath = self.mediaPath;
//        movieSeenedObject.fileName = self.mediaName;
//        movieSeenedObject.totalDuration = [NSNumber numberWithLongLong:_movieTotalDuration];
//        movieSeenedObject.seenedPercent = [NSNumber numberWithFloat:posPercent];
//        movieSeenedObject.lastUpdateDate = [NSDate date];
//        
//        [self cc_transASychronizeCall:@selector(updateMovieSeened:) param:movieSeenedObject];
//        g_backupSecondCount = 0;
//    }
    
//    NSString* strCurrentPostion = [self formatTime:currentPosition];
//    
//    _currentTimeLabel.text = strCurrentPostion;
    
//    [_footerViewController setIndicationTimeValue:[NSString stringWithFormat:@"%@/%@", strCurrentPostion, _strMovieTotalDuration]];
}

#pragma mark - KanKanSliderDelegate
-(void)kankanSliderValueChanged:(KanKanSlider*)sender value:(NSNumber*)nsValue{
    
    
}
//-(void)kankanSliderTouchesBegan:(KanKanSlider*)sender;
//-(void)kankanSliderTouchesMoved:(KanKanSlider*)sender;
//-(void)kankanSliderTouchesEnded:(KanKanSlider*)sender;
//-(void)kankanSliderTouchesCancelled:(KanKanSlider*)sender;

@end
