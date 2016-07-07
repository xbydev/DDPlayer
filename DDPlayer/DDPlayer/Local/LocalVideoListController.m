//
//  LocalVideoListController.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "LocalVideoListController.h"
#import "LocalVideoManager.h"
#import "LocalVideoInfo.h"
#import "PlayerViewController.h"
#import "KxMovieViewController.h"

@interface LocalVideoListController ()

@end

@implementation LocalVideoListController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _moviesModel = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本地视频";
    
    [self loadLocalMovies];
    
    [_tableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadLocalMovies{
    
    NSString *curDir = [[LocalVideoManager shareedLocalVideoManager] getRootPath];
    
    _moviesModel = [NSMutableArray arrayWithArray:[[LocalVideoManager shareedLocalVideoManager] scanCurrentPath:curDir]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _moviesModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
    }
    
    if (row < _moviesModel.count) {
        
        LocalVideoInfo *localVideoInfo = _moviesModel[row];
        cell.textLabel.text = localVideoInfo.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"the indexPath is %@",indexPath);
    
    NSInteger row = indexPath.row;
    
    if (row < _moviesModel.count) {
        
        LocalVideoInfo *localVideoInfo = _moviesModel[row];
        
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:localVideoInfo.path
                                                                                   parameters:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
        
//        PlayerViewController* playerCtrl = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
//        
//        NSString* mediaName = localVideoInfo.path;
//        NSString* mediaPath = localVideoInfo.name;
//        
//        //the actually media full path
//        playerCtrl.mediaPath = mediaPath;
//        playerCtrl.mediaName = mediaName;
//        
//        [self presentViewController:playerCtrl animated:YES completion:^{
//            
//        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
