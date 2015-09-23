//
//  ModelController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenTok/OpenTok.h>


@protocol ModelControllerDelegate;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
@property(nonatomic, assign) id <ModelControllerDelegate> delegate;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
@end

////////
@protocol ModelControllerDelegate <NSObject>
- (void)sessionDidConnect:(OTSession*)session;
-(void) didReceivePublisherVideo:(OTPublisher*) pub subscriberVideo:(OTSubscriber*) sub;

@end
