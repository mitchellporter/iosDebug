//
//  RootViewController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
-(void) publisherAsFirstView;
@end

