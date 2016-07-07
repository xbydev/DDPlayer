//
//  KanKanSlider.m
//  KanKanPlayer
//
//  Created by kevin on 12/22/12.
//  Copyright (c) 2012 xunlei. All rights reserved.
//


#import "KanKanSlider.h"
#import "NSBundle+Extension.h"
#import <QuartzCore/QuartzCore.h>


#define TOP_LEFT_MARGIN 6.0f

@implementation KanKanSlider
{
    
}

@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize value = _value;
@synthesize thumbState = _thumbState;
@synthesize bVSliderCtrl = _bVSliderCtrl;
@synthesize continuous = _continuous; 
@synthesize widthThumb = _widthThumb;
@synthesize heightThumb = _heightThumb;
@synthesize thumbRect = _thumbRect;
@synthesize imageBg = _imageBg;
@synthesize imageTrackBg = _imageTrackBg;
@synthesize imageThumbNormal = _imageThumbNormal;
@synthesize imageThumbHighlighted = _imageThumbHighlighted;
@synthesize imageThumbDisable = _imageThumbDisable;
@synthesize delegate = _delegate;


-(void)initKanKanSlider
{
    _minimumValue = 0;
    _maximumValue = 0;
    _value = 0;
    _bVSliderCtrl = NO;
    _continuous = YES;
    _widthThumb = 0;
    _heightThumb = 0;
    _imageBg = nil;
    _imageTrackBg = nil;
    _imageThumbNormal = nil;
    _imageThumbHighlighted = nil;
    _imageThumbDisable = nil;
    _thumbRect = CGRectZero;
    _thumbState = UIControlStateNormal;
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        [self initKanKanSlider];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initKanKanSlider];
    }
    
    return self;
}

-(void)deallocKanKanSlider
{
    _imageBg = nil;
    _imageTrackBg = nil;
    _imageThumbNormal = nil;
    _imageThumbHighlighted = nil;
    _imageThumbDisable = nil;
}

-(void)dealloc
{
    [self deallocKanKanSlider];
}

-(void)setValue:(long long)value
{
    if (_value != value)
	{
		if (value > _maximumValue)
		{
			_value = _maximumValue;
		}
		else if (value < _minimumValue)
		{
			_value = _minimumValue;
		}
		else
		{
			_value = value;
		}
        
        [self setNeedsDisplay];
	}
}

-(void)setImageBg:(UIImage*)imageBg
{
    _imageBg = imageBg;
}

-(void)setImageThumbNormal:(UIImage*)imageThumbNormal
{
    _imageThumbNormal = imageThumbNormal;
    _widthThumb = _imageThumbNormal.size.width/2;
    _heightThumb = _imageThumbNormal.size.height/2;
}

-(void)setImageThumbHighlighted:(UIImage*)imageThumbHighlighted
{
    _imageThumbHighlighted = imageThumbHighlighted;
}

-(void)setImageThumbDisable:(UIImage*)imageThumbDisable
{
    _imageThumbDisable = imageThumbDisable;
}

- (void)drawRect:(CGRect)rect
{    
    CGRect rectDraw = self.bounds;
    int nDiv = 0;
	int nWidth = 0;
	CGFloat ft = 0;
    
    //画底图
    if (_imageBg != nil)
    {
        rectDraw = self.bounds;
        CGSize szImageBg = {_imageBg.size.width/2, _imageBg.size.height/2};
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
	}
	else
	{
		nWidth = 0;
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

-(CGRect)thumbRect
{
    int nDiv = 0;
	int nWidth = 0;
	CGFloat ft = 0;
    
    _thumbRect = CGRectZero;
    
    if (_maximumValue > _minimumValue)
    {
        ft = (CGFloat)(_value - _minimumValue) / (_maximumValue - _minimumValue);
        ft = (CGFloat) ft * (self.bounds.size.width - _widthThumb);
        nWidth = (int)ft;
    }
    
    if (_imageThumbNormal != nil
        || _imageThumbHighlighted != nil
        || _imageThumbDisable != nil)
    {
        nDiv = (self.bounds.size.height - _heightThumb) / 2;
        assert(nDiv >= 0);
        _thumbRect = self.bounds;
        _thumbRect.origin.y += nDiv;
        _thumbRect.size.height -= 2*nDiv;
        _thumbRect.origin.x += nWidth;
        _thumbRect.size.width = _widthThumb;
    }
    
    return _thumbRect;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint xy = [touch locationInView:self];
    CGRect frame = self.bounds;
    int nOffset = 0;
    BOOL bValueChange = NO;
    
    if (_maximumValue <= _minimumValue)
	{
		return;
	}
    
	nOffset = (int)((CGFloat)(_value - _minimumValue) * (frame.size.width - _widthThumb) / (float)(_maximumValue - _minimumValue));
    
    //点击滑块
//	if (xy.x >= (frame.origin.x + nOffset) && xy.x <= (frame.origin.x + nOffset + _widthThumb))
	{
		_thumbState |= UIControlStateHighlighted;
	}
//	else	//点击其他位置
	{
		long long nPos = _value;
		CGFloat ft = 0;
		ft = (CGFloat)(xy.x - frame.origin.x - _widthThumb / 2) / (frame.size.width - _widthThumb);
		ft = ft * (_maximumValue - _minimumValue);
		nPos = (int)ft;
		nPos += _minimumValue;
        
		if (nPos > _maximumValue)
		{
			nPos = _maximumValue;
		}
		else if (nPos < _minimumValue)
		{
			nPos = _minimumValue;
		}
        
        if (_value != nPos)
        {
            _value = nPos;
            bValueChange = YES;
        }
	}
    
    if ([_delegate respondsToSelector:@selector(kankanSliderTouchesBegan:)])
    {
        [_delegate performSelector:@selector(kankanSliderTouchesBegan:) withObject:self];
    }
    
    if (bValueChange == YES)
    {
        if ([_delegate respondsToSelector:@selector(kankanSliderValueChanged:value:)])
        {
            [_delegate performSelector:@selector(kankanSliderValueChanged:value:)
                            withObject:self
                            withObject:[NSNumber numberWithUnsignedInt:_value]];
        }
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint xy = [touch locationInView:self];
    CGRect frame = self.bounds;
    
    if (_maximumValue <= _minimumValue)
    {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(kankanSliderTouchesMoved:)])
    {
        [_delegate performSelector:@selector(kankanSliderTouchesMoved:) withObject:self];
    }
    
	if (_thumbState & UIControlStateHighlighted)
	{
        long long nPos = _value;
        
        if (xy.x <= (frame.origin.x + _widthThumb/2))
        {
            nPos = _minimumValue;
        }
        else if (xy.x >= ((frame.origin.x+frame.size.width) - _widthThumb/2))
        {
            nPos = _maximumValue;
        }
        else
        {
            CGFloat ft = 0;
            ft = (CGFloat)(xy.x - (CGFloat)_widthThumb/2 - frame.origin.x)*
            (CGFloat)(_maximumValue - _minimumValue) / (CGFloat)(frame.size.width - _widthThumb);
            
            nPos = (int)ft;
            nPos += _minimumValue;
        }
        
        if (_value != nPos)
        {
            _value = nPos;
            
            if (_continuous == YES
                && [_delegate respondsToSelector:@selector(kankanSliderValueChanged:value:)]
                )
            {
                [_delegate performSelector:@selector(kankanSliderValueChanged:value:)
                                withObject:self
                                withObject:[NSNumber numberWithUnsignedInt:_value]];
            }
            
            [self setNeedsDisplay];
        }
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint xy = [touch locationInView:self];
    
    if ([_delegate respondsToSelector:@selector(kankanSliderTouchesEnded:)])
    {
        [_delegate performSelector:@selector(kankanSliderTouchesEnded:) withObject:self];
    }
    
    _thumbState &= ~UIControlStateHighlighted;
	[self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint xy = [touch locationInView:self];
    
    if ([_delegate respondsToSelector:@selector(kankanSliderTouchesCancelled:)])
    {
        [_delegate performSelector:@selector(kankanSliderTouchesCancelled:) withObject:self];
    }
}

@end

