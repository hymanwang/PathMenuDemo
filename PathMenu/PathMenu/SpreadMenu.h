//
//  SpreadMenu.h
//  PathMenu
//
//  Created by Hyman Wang on 7/23/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpreadMenuItem.h"

@class SpreadMenu;
@protocol SpreadMenuDelegate <NSObject>

- (void)spreadMenu:(SpreadMenu *)menu didSelectAtIndex:(NSInteger)index;

@end

@interface SpreadMenu : UIView<SpreadItemDelegate>

@property (strong, nonatomic) NSArray *menuArray;
@property (strong, nonatomic) SpreadMenuItem *addButton;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic, getter = isExpanding) BOOL expanding;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int flag;
@property (assign, nonatomic) id<SpreadMenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame menuArray:(NSArray *)menuArray;

@end
