//
//  AlbumVideoViewController.m
//  DDPlayer
//
//  Created by xiangbiying on 16/5/29.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import "AlbumVideoViewController.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "AlbumVideoInfo.h"
#import "AlbumVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AlbumVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ALAssetsLibrary *_library;
    NSMutableArray *_albumVideoInfos;
    
    IBOutlet UITableView *_tableView;
    
    MPMoviePlayerController *_moviePlayer;
}
@property(nonatomic, assign) BOOL isShowed;
@end

@implementation AlbumVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _albumVideoInfos = [[NSMutableArray alloc] initWithCapacity:50];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        //MPMoviePlayerController fullscreen 模式下，点击左上角的done按钮，会调用exitFullScreen通知。
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name: MPMoviePlayerDidExitFullscreenNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册视频";
    
    [self loadVideos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadVideos{
    ALAssetsLibrary *library1 = [[ALAssetsLibrary alloc] init];
    [library1 enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    AlbumVideoInfo *videoInfo = [[AlbumVideoInfo alloc] init];
                    videoInfo.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
//                    videoInfo.videoURL = [result valueForProperty:ALAssetPropertyAssetURL];
                    videoInfo.videoURL = result.defaultRepresentation.url;
                    videoInfo.duration = [result valueForProperty:ALAssetPropertyDuration];
                    videoInfo.name = [self getFormatedDateStringOfDate:[result valueForProperty:ALAssetPropertyDate]];
                    videoInfo.size = result.defaultRepresentation.size; //Bytes
                    videoInfo.format = [result.defaultRepresentation.filename pathExtension];
                    [_albumVideoInfos addObject:videoInfo];
                }
            }];
        } else {
            //没有更多的group时，即可认为已经加载完成。
             NSLog(@"after load, the total alumvideo count is %ld",_albumVideoInfos.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlbumVideos];
            });
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed.");
    }];
}

-(NSString*)getFormatedDateStringOfDate:(NSDate*)date{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"]; //注意时间的格式：MM表示月份，mm表示分钟，HH用24小时制，小hh是12小时制。
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (void)showAlbumVideos{
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumVideoInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    static NSString *const AlbumVideoCellIdentifier = @"AlbumVideoCellIdentifier";
    AlbumVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumVideoCellIdentifier];
    if (!cell) {
        cell = [AlbumVideoCell viewWithNib];
        [tableView registerNib:[UINib nibWithNibName:@"AlbumVideoCell" bundle:nil] forCellReuseIdentifier:AlbumVideoCellIdentifier];
    }
    cell.albumVideoInfo = _albumVideoInfos[row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row < _albumVideoInfos.count) {
        AlbumVideoInfo *albumVideoInfo = _albumVideoInfos[row];
        if (!_moviePlayer) {
            _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:albumVideoInfo.videoURL];
        }else{
            [_moviePlayer setContentURL:albumVideoInfo.videoURL];
        }
        _moviePlayer.view.frame = self.view.bounds;
        _moviePlayer.backgroundView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:_moviePlayer.view];
        
        _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        _moviePlayer.shouldAutoplay = YES;
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        [_moviePlayer setFullscreen:YES animated:YES];
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [_moviePlayer play];
    }
}

#pragma mark - handle notification

- (void)playDidChangeNotification:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playState = moviePlayer.playbackState;
    if (playState == MPMoviePlaybackStateStopped) {
        NSLog(@"停止");
    } else if(playState == MPMoviePlaybackStatePlaying) {
        NSLog(@"播放");
    } else if(playState == MPMoviePlaybackStatePaused) {
        NSLog(@"暂停");
    }
}

- (void)playMovieFinishedCallback:(NSNotification *)notification{
    
    NSLog(@"finish");
}

- (void)exitFullScreen:(NSNotification *)notification{
    
    NSLog(@"exitFullScreen");
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
}

@end
