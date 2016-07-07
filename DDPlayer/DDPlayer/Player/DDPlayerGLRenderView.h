//
//  DDPlayerGLRenderView.h
//  DDPlayer
//
//  Created by xiangbiying on 15/11/23.
//  Copyright © 2015年 xiangby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPlayerGLRenderView : UIView

- (int)connectGLContext;

- (int)postDrawFrame;

@end
