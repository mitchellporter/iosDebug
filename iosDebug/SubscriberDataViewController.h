//
//  SubscriberDataViewController.h
//  iosDebug
//
//  Created by Jaideep Shah on 9/23/15.
//  Copyright © 2015 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenTok/OpenTok.h>
#import "ModelController.h"

@interface SubscriberDataViewController : UIViewController <ModelControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *viewLoadingActivity;
@end
