//
//  KanKanSlider.h
//  KanKanPlayer
//
//  Created by kevin on 12/22/12.
//  Copyright (c) 2012 xunlei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KanKanSliderDelegate;

@interface KanKanSlider : UIControl
{
    long long       _minimumValue;
	long long       _maximumValue;
	long long       _value;
	NSUInteger      _thumbState;
	BOOL            _bVSliderCtrl;
    BOOL            _continuous;
    NSUInteger      _widthThumb;
    NSUInteger      _heightThumb;
    CGRect          _thumbRect;
    UIImage*        _imageBg;                 //背景
    UIImage*        _imageTrackBg;            //已使用的背景
    UIImage*        _imageThumbNormal;        //滑块
    UIImage*        _imageThumbHighlighted;   //滑块
    UIImage*        _imageThumbDisable;       //滑块
}


@property (nonatomic, assign) long long  minimumValue;
@property (nonatomic, assign) long long  maximumValue;
@property (nonatomic, assign) long long  value;
@property (nonatomic, assign) NSUInteger thumbState;
@property (nonatomic, assign) BOOL bVSliderCtrl;
@property(nonatomic,getter=isContinuous) BOOL continuous; 
@property (nonatomic, assign) NSUInteger widthThumb;
@property (nonatomic, assign) NSUInteger heightThumb;
@property (nonatomic, assign) CGRect thumbRect;
@property (nonatomic, strong) UIImage* imageBg;                 //背景
@property (nonatomic, strong) UIImage* imageTrackBg;            //已使用的背景
@property (nonatomic, strong) UIImage* imageThumbNormal;        //滑块
@property (nonatomic, strong) UIImage* imageThumbHighlighted;   //滑块
@property (nonatomic, strong) UIImage* imageThumbDisable;       //滑块


@property (nonatomic, assign)id<KanKanSliderDelegate> delegate;


-(CGRect)thumbRect;

//继承此控件的请在dealloc调用此接口
-(void)deallocKanKanSlider;

@end


@protocol KanKanSliderDelegate <NSObject>
-(void)kankanSliderValueChanged:(KanKanSlider*)sender value:(NSNumber*)nsValue;
@optional
-(void)kankanSliderTouchesBegan:(KanKanSlider*)sender;
-(void)kankanSliderTouchesMoved:(KanKanSlider*)sender;
-(void)kankanSliderTouchesEnded:(KanKanSlider*)sender;
-(void)kankanSliderTouchesCancelled:(KanKanSlider*)sender;

@end

