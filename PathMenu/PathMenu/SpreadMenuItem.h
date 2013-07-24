//
//  SpreadMenuItem.h
//  PathMenu
//
//  Created by Hyman Wang on 7/23/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpreadItemDelegate;

@interface SpreadMenuItem : UIImageView

@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;
@property (assign, nonatomic) CGPoint nearPoint;
@property (assign, nonatomic) CGPoint farPoint;
@property (retain, nonatomic) UIImageView *contentImageView;

@property (assign, nonatomic) id<SpreadItemDelegate> delegate;

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage contentImage:(UIImage *)contentImage highlightedcontentImage:(UIImage *)highlightedcontentImage;

@end

@protocol SpreadItemDelegate <NSObject>

- (void)spreadItemTouchBegan:(SpreadMenuItem *)item;
- (void)spreadItemTouchEnd:(SpreadMenuItem *)item;

@end

