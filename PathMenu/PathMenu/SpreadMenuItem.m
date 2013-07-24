//
//  SpreadMenuItem.m
//  PathMenu
//
//  Created by Hyman Wang on 7/23/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "SpreadMenuItem.h"

@implementation SpreadMenuItem

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage contentImage:(UIImage *)contentImage highlightedcontentImage:(UIImage *)highlightedcontentImage
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = image;
        self.highlightedImage = highlightedImage;
        _contentImageView = [[UIImageView alloc] initWithImage:contentImage
                                              highlightedImage:highlightedcontentImage];
        [self addSubview:_contentImageView];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width / 2 - width / 2,
                                         self.bounds.size.height / 2 - height / 2,
                                         width,
                                         height);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(spreadItemTouchBegan:)])
    {
        [_delegate spreadItemTouchBegan:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, location))
    {
        self.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.bounds, location))
    {
        if ([_delegate respondsToSelector:@selector(spreadItemTouchEnd:)])
        {
            [_delegate spreadItemTouchEnd:self];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self.contentImageView setHighlighted:highlighted];
}

@end
