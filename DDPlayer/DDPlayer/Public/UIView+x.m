//
//  UIViewx.m
//  MemoLite
//
//  Created by czh0766 on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIView+x.h"
#import "iMacro.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static char USER_DATA_KEY;

@implementation UIView (UIViewx)

+(id) viewWithNib:(NSString*)nib owner:(id)owner {
    @try {
        NSArray* array =[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil];
        return [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        NSLog(@"load nib exception: %@", exception.reason);
        return nil;
    }
}

+(id) viewWithNib {
    return [self viewWithNib:NSStringFromClass(self) owner:nil];
    
}

-(void) offset:(CGPoint)point { 
    CGRect frame = self.frame;
    frame.origin.x += point.x;
    frame.origin.y += point.y;
    self.frame = frame;
}

-(void) setPosition:(CGPoint)position {
    CGRect frame = self.frame;
    frame.origin.x = position.x;
    frame.origin.y = position.y; 
    self.frame = frame;
}

-(void) setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)position {
    return self.frame.origin;
}

-(CGSize)size {
    return self.frame.size;
}

-(CGPoint)boundsCenter {
    CGSize size = self.bounds.size;
    return CGPointMake(size.width/2, size.height/2);
}

-(CGFloat) left {
    return self.frame.origin.x;
}

-(CGFloat) top {
    return self.frame.origin.y;
}

-(CGFloat) right {
    return [self left] + [self width];
}

-(CGFloat) bottom {
    return [self top] + [self height];
}

-(CGFloat) width {
    return self.frame.size.width;
}

-(CGFloat) height {
    return self.frame.size.height;
}

-(void) setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame; 
}

-(void) setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

-(void) setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

-(void) setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


-(void) setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame; 
}

-(void) setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;  
}    

-(void) clearSubviews {
    id subviews = self.subviews;
    NSInteger count = [subviews count];
    for (int i = 0; i < count; i++) {
        [[subviews objectAtIndex:i] removeFromSuperview];
    }
}

-(void) replaceView:(UIView*)view atIndex:(int)index {
    UIView* view0 = [self viewAtIndex:index];
    view.frame = view0.frame;
    [view0 removeFromSuperview];
    [self insertSubview:view atIndex:index];
}

-(void) replaceView:(UIView*)view withView:(UIView*)newView {
    int index = [self indexOfView:view];
    newView.frame = view.frame;
    [view removeFromSuperview];
    [self insertSubview:newView atIndex:index];
}

-(UIView*) viewAtIndex:(int)index {
    if (index < self.subviews.count) {
        return [self.subviews objectAtIndex:index];
    }
    return nil;
}

-(void) removeViewAtIndex:(int)index {
    UIView* view = [self viewAtIndex:index];
    [view removeFromSuperview];
}

-(void) transitionToAddSubview:(UIView*)view duration:(NSTimeInterval)duration {
    [self addSubview:view];
    view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1;
    }];
}

-(void) transitionToRemoveFromSuperview:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [self removeFromSuperview];
    }];
}

-(void) makeFlexibleSize {
    self.autoresizingMask = UIViewAutoresizingFlexibleSize;
    for (UIView* view in self.subviews) {
        [view makeFlexibleSize];
    }
}

-(BOOL) pointInsideFrame:(CGPoint)location {
    location.x -= [self left];
    location.y -= [self top];
    return [self pointInside:location withEvent:nil];
}

-(int) indexOfView:(UIView*)view {
    return [self.subviews indexOfObject:view];
}

-(UITapGestureRecognizer*)addTapGestureRecognizer:(id)target forAction:(SEL)action {
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

-(UILongPressGestureRecognizer*)addLongPressGestureRecognizer:(id)target forAction:(SEL)action {
    UILongPressGestureRecognizer* recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

-(void) makeFrameIntegral {
    self.frame = CGRectIntegral(self.frame);
}

-(void) layoutSubviewsInCenter:(float)margin {
    float width = 0;
    for (UIView* view in self.subviews) {
        if (!view.hidden) {
            width += [view width] + margin;
        }
    }
    width -= margin;
    
    float offx = ([self width] - width) / 2;
    float offy = [self height] / 2;
    for (UIView* view in self.subviews) {
        if (!view.hidden) {
            float w = [view width];
            view.center = CGPointMake(offx + w / 2, offy);
            [view makeFrameIntegral];
            offx += w + margin;
        }
    }
}

-(void)setUserData:(id)userData {
    objc_setAssociatedObject(self, &USER_DATA_KEY, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)userData {
    return objc_getAssociatedObject(self, &USER_DATA_KEY);
}

-(UIImage*) snapshotImage {
    float scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

-(id) findSuperViewWithClass:(Class)clazz {
    UIView* superview = self.superview;
    while (superview && ![superview isKindOfClass:clazz]) {
        superview = superview.superview;
    }
    return superview;
}

- (void)giveBorderWithCornerRadious:(CGFloat)radius borderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth
{
    CGRect rect = self.bounds;
    
    //Make round
    // Create the path for to make circle
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = rect;
    maskLayer.path  = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
    
    //Give Border
    //Create path for border
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.frame       = rect;
    borderLayer.path        = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    borderLayer.lineWidth   = borderWidth;
    
    //Add this layer to give border.
    [[self layer] addSublayer:borderLayer];
}

@end
