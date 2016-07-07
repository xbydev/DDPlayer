//
//  KanKanProgressSlider
//  KanKanPlayer
//
//  Created by kevin on 12/25/12.
//  Copyright (c) 2012 xunlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KanKanSlider.h"

@protocol KanKanSliderDelegate;

@interface KanKanProgressSlider : KanKanSlider
{
    
}

@property (nonatomic, assign) long long bufferValue;
@property (nonatomic, strong) UIImage* imageBufferBg;   //缓冲背景

- (void)fadePopupTimeViewInAndOut:(BOOL)aFadeIn;
- (void)positionAndUpdatePopupTimeView;

@end


