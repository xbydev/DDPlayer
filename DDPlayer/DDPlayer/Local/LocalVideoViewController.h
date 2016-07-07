//
//  LocalVideoViewController.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/20.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalVideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
}
@end
