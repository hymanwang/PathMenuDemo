//
//  ViewController.m
//  PathMenu
//
//  Created by Hyman Wang on 7/23/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backgroundMenuItemImage = [UIImage imageNamed:@"story-button.png"];
    UIImage *backgroundMenuItemImagePressed = [UIImage imageNamed:@"story-button-pressed.png"];

    SpreadMenuItem *cameraMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-camera.png"]
                                                   highlightedcontentImage:nil];
    SpreadMenuItem *peopleMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-people.png"]
                                                   highlightedcontentImage:nil];
    SpreadMenuItem *placeMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-place.png"]
                                                   highlightedcontentImage:nil];
    SpreadMenuItem *musicMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-music.png"]
                                                   highlightedcontentImage:nil];
    SpreadMenuItem *thoughtMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-thought.png"]
                                                   highlightedcontentImage:nil];
    SpreadMenuItem *sleepMenuItem = [[SpreadMenuItem alloc] initWithImage:backgroundMenuItemImage
                                                          highlightedImage:backgroundMenuItemImagePressed
                                                              contentImage:[UIImage imageNamed:@"story-sleep.png"]
                                                   highlightedcontentImage:nil];
    
    
    NSArray *menuItemArray = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, musicMenuItem, thoughtMenuItem, sleepMenuItem, nil];
    SpreadMenu *menuView = [[SpreadMenu alloc] initWithFrame:self.view.frame menuArray:menuItemArray];
    [menuView setStartPoint:CGPointMake(40.0f, [UIScreen mainScreen].bounds.size.height - 80.0f)];
    menuView.delegate = self;
    [self.view addSubview:menuView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sread menu delegate

- (void)spreadMenu:(SpreadMenu *)menu didSelectAtIndex:(NSInteger)index
{
    NSLog(@"select menu at: %d", index);
}

@end
