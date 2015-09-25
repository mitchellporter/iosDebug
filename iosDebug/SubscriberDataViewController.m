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
-(void) viewDidAppear:(BOOL)animated
{
    [self.viewLoadingActivity startAnimating];
    [super viewDidAppear:animated];
}

#pragma mark ModelControllerDataSource


-(void) modelController:(ModelController *)model didReceiveVideo:(id)objHavingVideoView
{
    if(objHavingVideoView == nil) return;
    
    OTSubscriber * subscriber = (OTSubscriber *) objHavingVideoView;
    [subscriber.view setFrame:CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
    [self.videoView addSubview:subscriber.view];
    [self.viewLoadingActivity stopAnimating];
}

@end
