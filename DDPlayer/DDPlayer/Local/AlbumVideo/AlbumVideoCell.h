//
//  AlumVideoCell.h
//  DDPlayer
//
//  Created by xiangbiying on 16/6/12.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumVideoInfo.h"

@interface AlbumVideoCell : UITableViewCell{
    
    IBOutlet UIView *_thumbNailView;
    IBOutlet UIImageView *_thumbNailImgView;
    IBOutlet UILabel *_formatLabel;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_sizeLabel;
    IBOutlet UILabel *_durationLabel;
}

@property(nonatomic, strong)AlbumVideoInfo *albumVideoInfo;

@end
