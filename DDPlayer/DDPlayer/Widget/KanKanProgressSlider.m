//
//  KanKanSlider.m
//  KanKanPlayer
//
//  Created by kevin on 12/22/12.
//  Copyright (c) 2012 xunlei. All rights reserved.
//


#import "KanKanProgressSlider.h"
#import "NSBundle+Extension.h"
#import <QuartzCore/QuartzCore.h>
#import "KanKanPopoverView.h"


#define TOP_LEFT_MARGIN 6.0f

@implementation KanKanProgressSlider
{
    KanKanPopoverView *_scrubTimeView;
}

@synthesize bufferValue = _bufferValue;
@synthesize imageBufferBg = _imageBufferBg;

-(void)initKanKanProgressSlider
{
    _bufferValue = 0;
    _imageBufferBg = nil;
    
    if (_scrubTimeView == nil)
    {
        _scrubTimeView = [[KanKanPopoverView alloc] initWithFrame:CGRectZero];
        _scrubTimeView.alpha = 0.0f;
        _scrubTimeView.backgroundColor = [UIColor clearColor];
        
#if 0
        UIImage* imageTimeWndBg = [UIImage imageWithContentsOfFile:[[NSBundle myResourcesBundle] pathForResource:@"time_wnd" ofType:@"png"]];
        _scrubTimeView.imageBg = imageTimeWndBg;
        CGRect bounds = _scrubTimeView.bounds;
        CGSize szImageBg = {imageTimeWndBg.size.width/2, imageTimeWndBg.size.height/2};
        bounds.size = szImageBg;
        _scrubTimeView.bounds = bounds;
#endif
        
        [self addSubview:_scrubTimeView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        [self initKanKanProgressSlider];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initKanKanProgressSlider];
    }
    
    return self;
}

-(void)dealloc
{
    [self deallocKanKanSlider];
    _bufferValue = 0;
    _imageBufferBg = nil;
}

- (void)fadePopupTimeViewInAndOut:(BOOL)aFadeIn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    if (aFadeIn)
    {
        _scrubTimeView.alpha = 1.0f;
    }
    else
    {
        _scrubTimeView.alpha = 0.0f;
    }
    
    [UIView commitAnimations];
}

- (void)positionAndUpdatePopupTimeView
{
    CGRect thumbRect = [self thumbRect];
    CGRect popupRect = CGRectOffset(thumbRect, 0, -(thumbRect.size.height+10));
    popupRect = CGRectInset(popupRect, -20, -10);
    
#if 1
    _scrubTimeView.frame = popupRect;
#else
    _scrubTimeView.center = CGPointMake(
        popupRect.origin.x + popupRect.size.width/2,
        popupRect.origin.y + popupRect.size.height/2
    );
#endif
    
    [_scrubTimeView setText:[NSString stringWithFormat:@"%@", [self _formatTime:self.value]]];
}

-(void)setBufferValue:(long long)bufferValue
{
    if (_bufferValue != bufferValue)
	{
		if (bufferValue > _maximumValue)
		{
			_bufferValue = _maximumValue;
		}
		else if (bufferValue < _minimumValue)
		{
			_bufferValue = _minimumValue;
		}
		else
		{
			_bufferValue = bufferValue;
		}
        
        [self setNeedsDisplay];
	}
}

-(void)setImageBufferBg:(UIImage*)imageBufferBg
{
    _imageBufferBg = imageBufferBg;
}

- (void)drawRect:(CGRect)rect
{
    CGRect rectDraw = self.bounds;
    int nDiv = 0;
	int nWidth = 0;
    int nBufferWidth = 0;
	CGFloat ft = 0;
    
    //画底图
    if (_imageBg != nil)
    {
        rectDraw = self.bounds;
        CGSize szImageBg = _imageBg.size;
		int nDiv = (rectDraw.size.height - szImageBg.height) / 2;
        assert(nDiv >= 0);
		rectDraw.origin.y += nDiv;
		rectDraw.size.height -= 2*nDiv;
        
        UIImage* image = _imageBg;
        image = [image stretchableImageWithLeftCapWidth:TOP_LEFT_MARGIN topCapHeight:0];
        [image drawInRect:rectDraw];
    }
    
	if (_maximumValue > _minimumValue)
	{
        rectDraw = self.bounds;
		ft = (CGFloat)(_value - _minimumValue) / (_maximumValue - _minimumValue);
		ft = (CGFloat) ft * (rectDraw.size.width - _widthThumb);
		nWidth = (int)ft;
        
        if (_bufferValue == _maximumValue)
        {
            nBufferWidth = rectDraw.size.width-_widthThumb / 2;
        }
        else
        {
            ft = (CGFloat)(_bufferValue - _minimumValue) / (_maximumValue - _minimumValue);
            ft = (CGFloat) ft * (rectDraw.size.width - _widthThumb);
            nBufferWidth = (int)ft;
        }
	}
	else
	{
		nWidth = 0;
        nBufferWidth = 0;
	}
    
    //缓冲底
    CGSize szBufferBg = {_imageBufferBg.size.width/2, _imageBufferBg.size.height/2};
	if (_imageBufferBg != nil && nBufferWidth != 0)
	{
        rectDraw = self.bounds;
		nDiv = (rectDraw.size.height - szBufferBg.height) / 2;
		rectDraw.origin.y += nDiv;
		rectDraw.size.height -= 2*nDiv;
		rectDraw.size.width = nBufferWidth + _widthThumb / 2;
        
        UIImage* image = _imageBufferBg;
        image = [image stretchableImageWithLeftCapWidth:TOP_LEFT_MARGIN topCapHeight:0];
        [image drawInRect:rectDraw];
	}
    
	//选中底
    CGSize szTrackBg = {_imageTrackBg.size.width/2, _imageTrackBg.size.height/2};
	if (_imageTrackBg != nil && nWidth != 0)
	{
        rectDraw = self.bounds;
		nDiv = (rectDraw.size.height - szTrackBg.height) / 2;
		rectDraw.origin.y += nDiv;
		rectDraw.size.height -= 2*nDiv;
		rectDraw.size.width = nWidth + _widthThumb / 2;
        
        UIImage* image = _imageTrackBg;
        image = [image stretchableImageWithLeftCapWidth:TOP_LEFT_MARGIN topCapHeight:0];
        [image drawInRect:rectDraw];
	}
    
	//滑块
	if (_imageThumbNormal != nil
        || _imageThumbHighlighted != nil
        || _imageThumbDisable != nil)
	{
        rectDraw = self.thumbRect;
        
        if (self.userInteractionEnabled == NO
            || self.enabled == NO
            )
		{
            //无效状态
            if (_imageThumbDisable == nil)
            {
                _imageThumbDisable = _imageThumbNormal;
            }
            
            [_imageThumbDisable drawInRect:_thumbRect];
		}
		else
		{
            if (_thumbState & UIControlStateHighlighted)
            {
                [_imageThumbHighlighted drawInRect:_thumbRect];
            }
            else
            {
                [_imageThumbNormal drawInRect:_thumbRect];
            }
		}
	}
}

- (NSString *)_formatTime:(float)second
{
    int diff = (int)second;

    int iHour = diff / (60.0f * 60.0f);;
    
    diff = diff % (60 * 60);
    int iMinute = diff / 60.0f;
    
    int iSecond = diff % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", iHour, iMinute, iSecond];
}

@end

