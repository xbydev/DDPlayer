//
//  LocalVideoListController.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalVideoListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_moviesModel;
}

@end
