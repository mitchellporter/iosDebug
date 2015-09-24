//
//  SubscriberDataViewController.m
//  iosDebug
//
//  Created by Jaideep Shah on 9/23/15.
//  Copyright © 2015 Jaideep Shah. All rights reserved.
//

#import "SubscriberDataViewController.h"

@interface SubscriberDataViewController ()

@end

@implementation SubscriberDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ModelControllerDelegate
- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(void) didReceivePublisherVideo:(OTPublisher *)publisher subscriberVideo:(OTSubscriber *)subscriber
{
    if(publisher && !subscriber)
    {
        [publisher.view setFrame:CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
        [self.videoView addSubview:publisher.view];
        
    } else if((publisher && subscriber) || (!publisher && subscriber))
    {
        
        [subscriber.view setFrame:CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
        [self.videoView addSubview:subscriber.view];
        
    }
}

@end
