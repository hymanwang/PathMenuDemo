//
//  SpreadMenu.m
//  PathMenu
//
//  Created by Hyman Wang on 7/23/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "SpreadMenu.h"
#import <QuartzCore/QuartzCore.h>

#define NEARRADIUS 130.0f
#define ENDRADIUS 140.0f
#define FARRADIUS 160.0f
#define VIEMBEGINTAG 1000

@implementation SpreadMenu

- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuArray = [NSArray arrayWithArray:menuArray];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)setStartPoint:(CGPoint)startPoint
{
    int count = _menuArray.count;
    for (int i = 0; i < count; i++) {
        SpreadMenuItem *item = [_menuArray objectAtIndex:i];
        item.tag = VIEMBEGINTAG + i;
        item.startPoint = startPoint;
        item.endPoint = CGPointMake(startPoint.x + ENDRADIUS * sinf(i * M_PI_2 / (count - 1)),
                                    startPoint.y - ENDRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.nearPoint = CGPointMake(startPoint.x + NEARRADIUS * sinf(i * M_PI_2 / (count - 1)),
                                     startPoint.y - NEARRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.farPoint = CGPointMake(startPoint.x + FARRADIUS * sinf(i * M_PI_2 / (count - 1)),
                                    startPoint.y - FARRADIUS * cosf(i * M_PI_2 / (count - 1)));
        item.center = item.startPoint;
        item.delegate = self;
        [self addSubview:item];
    }
    self.addButton = [[SpreadMenuItem alloc] initWithImage:[UIImage imageNamed:@"story-add-button.png"]
                                          highlightedImage:[UIImage imageNamed:@"story-add-button-pressed.png"]
                                              contentImage:[UIImage imageNamed:@"story-add-plus.png"]
                                   highlightedcontentImage:[UIImage imageNamed:@"story-add-plus-pressed.png"]];
    self.addButton.delegate = self;
    [self.addButton setCenter:startPoint];
    [self addSubview:self.addButton];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (YES == _expanding) {
        return YES;
    } else {
        return CGRectContainsPoint(_addButton.frame, point);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.expanding = !self.isExpanding;
}

#pragma mark - spread menu item delegate

- (void)spreadItemTouchBegan:(SpreadMenuItem *)item
{
    if (item == _addButton) {
        self.expanding = !self.isExpanding;
    }
}

- (void)spreadItemTouchEnd:(SpreadMenuItem *)item
{
    if (item == _addButton) {
        return;
    }
    
    CAAnimationGroup *blowup = [self blowUpAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    for (int i = 0; i < self.menuArray.count; i++) {
        SpreadMenuItem *otherItem = [self.menuArray objectAtIndex:i];
        CAAnimationGroup *shrink = [self shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        otherItem.center = otherItem.startPoint;
    }
    _expanding = NO;
    
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.2f animations:^{
        _addButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if ([self.delegate respondsToSelector:@selector(spreadMenu:didSelectAtIndex:)]) {
        [self.delegate spreadMenu:self didSelectAtIndex:item.tag - VIEMBEGINTAG];
    }
}

#pragma mark - expand and close menus

- (void)setExpanding:(BOOL)expanding
{
    _expanding = expanding;
    
    float angle = self.isExpanding? M_PI_4:0.0;
    [UIView animateWithDuration:0.2 animations:^{
        _addButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if (!_timer) {
        _flag = self.isExpanding ? 0 : 5;
        SEL selector = self.isExpanding ? @selector(expand) : @selector(close);
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:selector userInfo:nil repeats:YES] ;
    }
}

- (void)expand
{
    if (_flag == 6) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    int viewTag = VIEMBEGINTAG + _flag;
    SpreadMenuItem *spreadItem = (SpreadMenuItem *)[self viewWithTag:viewTag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, spreadItem.startPoint.x, spreadItem.startPoint.y);
    CGPathAddLineToPoint(path, NULL, spreadItem.farPoint.x, spreadItem.farPoint.y);
    CGPathAddLineToPoint(path, NULL, spreadItem.nearPoint.x, spreadItem.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, spreadItem.endPoint.x, spreadItem.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    [spreadItem.layer addAnimation:positionAnimation forKey:@"expand"];
    spreadItem.center = spreadItem.endPoint;
    
    _flag++;
}

- (void)close
{
    if (_flag == -1) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    int viewTag = VIEMBEGINTAG + _flag;
    SpreadMenuItem *spreadItem = (SpreadMenuItem *)[self viewWithTag:viewTag];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, spreadItem.endPoint.x, spreadItem.endPoint.y);
    CGPathAddLineToPoint(path, NULL, spreadItem.farPoint.x, spreadItem.farPoint.y);
    CGPathAddLineToPoint(path, NULL, spreadItem.startPoint.x, spreadItem.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 4];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:positionAnimation,rotationAnimation, nil];
    animationGroup.duration = 0.5f;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [spreadItem.layer addAnimation:animationGroup forKey:@"expand"];
    spreadItem.center = spreadItem.startPoint;
    
    _flag--;
}

- (CAAnimationGroup *)blowUpAnimationAtPoint:(CGPoint)point
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:positionAnimation, opacityAnimation, scaleAnimation, nil];
    group.duration = 0.5f;
    group.fillMode = kCAFillModeForwards;
    
    return group;
}

- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)point
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:positionAnimation, opacityAnimation, scaleAnimation, nil];
    group.duration = 0.5f;
    group.fillMode = kCAFillModeForwards;
    return group;
}

@end
