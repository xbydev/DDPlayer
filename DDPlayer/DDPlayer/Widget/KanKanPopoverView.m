//
//  KanKanPopoverView.m
//  PlayerComponent
//
//  Created by xunlei on 9/1/12.
//
//

#import "KanKanPopoverView.h"

@implementation KanKanPopoverView

@synthesize font = _font;
@synthesize text = _text;
@synthesize imageBg = _imageBg;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.font = [UIFont boldSystemFontOfSize:14];
        self.imageBg = nil;
    }
    
    return self;
}

- (void)dealloc
{
    self.text = nil;
    self.font = nil;
    self.imageBg = nil;
}

- (void)drawRect:(CGRect)rect
{
#if 1
    // Set the fill color
	[[UIColor colorWithWhite:0 alpha:0.8] setFill];
    
    // Create the path for the rounded rectanble
    CGRect roundedRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height * 0.8);
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:4.0];
    
    // Create the arrow path
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGPoint p0 = CGPointMake(midX, CGRectGetMaxY(self.bounds));
    [arrowPath moveToPoint:p0];
    [arrowPath addLineToPoint:CGPointMake((midX - 10.0), CGRectGetMaxY(roundedRect))];
    [arrowPath addLineToPoint:CGPointMake((midX + 10.0), CGRectGetMaxY(roundedRect))];
    [arrowPath closePath];
    
    // Attach the arrow path to the buble
    [roundedRectPath appendPath:arrowPath];
    
    [roundedRectPath fill];
#else
    CGRect roundedRect = self.bounds;
    [_imageBg drawInRect:roundedRect];
#endif
    
    // Draw the text
    if (self.text)
    {
        [[UIColor colorWithWhite:1 alpha:0.8] set];
        CGSize s = [_text sizeWithFont:self.font];
        CGFloat yOffset = (roundedRect.size.height - s.height) / 2;
        CGRect textRect = CGRectMake(roundedRect.origin.x, yOffset, roundedRect.size.width, s.height);
        
        [_text drawInRect:textRect
                 withFont:self.font
            lineBreakMode:UILineBreakModeWordWrap
                alignment:UITextAlignmentCenter];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

@end
