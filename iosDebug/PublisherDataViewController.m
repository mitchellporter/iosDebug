//
//  PublisherDataViewController.m
//  iosDebug
//
//  Created by Jaideep Shah on 9/23/15.
//  Copyright © 2015 Jaideep Shah. All rights reserved.
//

#import "PublisherDataViewController.h"

@interface PublisherDataViewController ()

@end

@implementation PublisherDataViewController

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
#pragma mark ModelControllerDelegate
-(void) modelController:(ModelController *)model sessionDidConnect:(OTSession *)session
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(void) modelController:(ModelController *)model didReceiveVideo:(id)objHavingVideoView
{
    if(objHavingVideoView == nil) return;
    
    OTPublisher * publisher = (OTPublisher *) objHavingVideoView;
    [publisher.view setFrame:CGRectMake(0, 0, self.videoView.frame.size.width, self.videoView.frame.size.height)];
    [self.videoView addSubview:publisher.view];
    [self.viewLoadingActivity stopAnimating];
}

@end
