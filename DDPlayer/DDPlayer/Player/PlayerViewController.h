//
//  PlayerViewController.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/23.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PlayerAdapterProtocol.h"
#import "KanKanProgressSlider.h"

@interface PlayerViewController : UIViewController{
    
    IBOutlet UIView *_topView;
    
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UIView *_bottomView;
    
    IBOutlet UILabel *_currentTimeLabel;
    
    IBOutlet KanKanProgressSlider *_progressSlider;
    
    IBOutlet UILabel *_totalTimeLabel;
    
    IBOutlet UIButton *_airplayBtn;
    
    IBOutlet UIButton *_subtitleBtn;
    
    IBOutlet UIButton *_playBtn;
    
    IBOutlet UISlider *_volumeSlider;
    
    IBOutlet UIButton *_fullScreenBtn;
}

@property(nonatomic, copy) NSString* mediaPath;

@property(nonatomic, copy) NSString* mediaName;

@end
