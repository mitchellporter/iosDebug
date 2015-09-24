//
//  ModelController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenTok/OpenTok.h>
#import "RootViewController.h"


@protocol ModelControllerDelegate;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

@property(nonatomic, weak) id <ModelControllerDelegate> delegate;

- (instancetype)initWithRootViewController:(RootViewController *) rvc ;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
@end

////////
@protocol ModelControllerDelegate <NSObject>
@optional
- (void) modelController:(ModelController*)model sessionDidConnect:(OTSession*)session;
- (void) modelController:(ModelController*)model didReceiveVideo:(id) objHavingVideoView;
@end
