//
//  KxMovieGLView.h
//  DDPlayer
//
//  Created by xiangbiying on 16/4/23.
//  Copyright © 2016年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KxVideoFrame;
@class KxMovieDecoder;

@interface KxMovieGLView : UIView

- (id) initWithFrame:(CGRect)frame
             decoder: (KxMovieDecoder *) decoder;

- (void) render: (KxVideoFrame *) frame;

@end
