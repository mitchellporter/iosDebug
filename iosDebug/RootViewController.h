//
//  RootViewController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController,ModelController;

@protocol RootViewControllerDelegate <NSObject>
@optional
- (void) modelController:(ModelController *)model jumpToPageView:(NSUInteger) index;
@end


@interface RootViewController : UIViewController <UIPageViewControllerDelegate , RootViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

////////
