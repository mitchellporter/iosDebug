//
//  ModelController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class ModelController;

////////
@protocol ModelControllerDataSource <NSObject>
@optional
- (void) modelController:(ModelController*)model didReceiveVideo:(id) objHavingVideoView;
@end



@interface ModelController : NSObject <UIPageViewControllerDataSource , ModelControllerDataSource>

@property (nonatomic, weak) id <RootViewControllerDelegate> rootViewControllerDelegate;
- (instancetype)initWithRootViewController:(RootViewController *) rvc ;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;

@end

