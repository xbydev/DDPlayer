//
//  LocalVideoViewController.m
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import "LocalVideoViewController.h"
#import "LocalVideoListController.h"
#import "AlbumVideoViewController.h"

@interface LocalVideoViewController ()

@end

@implementation LocalVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    static NSString *UITableViewCellIdentifier = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIdentifier];
    }
    
    if (0 == section) {
        
        cell.textLabel.text = @"本地视频";
    }else if (1 == section){
        
        cell.textLabel.text = @"相册视频";
    }else if (2 == section){
        
        cell.textLabel.text = @"观看记录";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"the indexPath is %@",indexPath);
    
    NSInteger section = indexPath.section;
    
    if (0 == section) {
        
        LocalVideoListController *localVideoListCtrl = [[LocalVideoListController alloc] initWithNibName:@"LocalVideoListController" bundle:nil];
        [self.navigationController pushViewController:localVideoListCtrl animated:YES];
    }else if (1 == section){
        
        AlbumVideoViewController *albumVideoCtrl = [[AlbumVideoViewController alloc] initWithNibName:@"AlbumVideoViewController" bundle:nil];
        [self.navigationController pushViewController:albumVideoCtrl animated:YES];
    }
}

@end
