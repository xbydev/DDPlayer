//
//  AlumVideoCell.m
//  DDPlayer
//
//  Created by xiangbiying on 16/6/12.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import "AlbumVideoCell.h"

@implementation AlbumVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _thumbNailImgView.contentMode = UIViewContentModeScaleAspectFit;
    _thumbNailImgView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbumVideoInfo:(AlbumVideoInfo *)albumVideoInfo{
    
    _thumbNailImgView.image = albumVideoInfo.thumbnail;
    _formatLabel.text = albumVideoInfo.format;
    _nameLabel.text = albumVideoInfo.name;
    _durationLabel.text = [self formatedVideoDurationStrWithDuration:albumVideoInfo.duration.longLongValue];
    _sizeLabel.text = [self formatedVideSizeStrWithSize:albumVideoInfo.size];
    [self layoutSubviews];
}

- (NSString *)formatedVideoDurationStrWithDuration:(long long)durationInSeconds{
    
    long long diff = durationInSeconds;
    NSInteger iHour = diff / (60.0f * 60.0f);;
    
    diff = diff % (60 * 60);
    NSInteger iMinute = diff / 60.0f;
    
    NSInteger iSecond = diff % 60;
    if (iHour > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", iHour, iMinute, iSecond];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld", iMinute, iSecond];
}

- (NSString *)formatedVideSizeStrWithSize:(long long)sizeInBytes{
    
    NSString *resutl = nil;
    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    
    if (sizeInBytes >= gb) {
        
        resutl = [NSString stringWithFormat:@"%.1f GB",(float)sizeInBytes/gb];
    } else if (sizeInBytes >= mb) {
        
        resutl = [NSString stringWithFormat:@"%.1f MB",(float)sizeInBytes/mb];
    } else if (sizeInBytes >= kb) {
        
        resutl = [NSString stringWithFormat:@"%.1f KB",(float)sizeInBytes/kb];
    } else
        
        resutl = [NSString stringWithFormat:@"%.1f B",(float)sizeInBytes];
    
    return resutl;
}

@end
