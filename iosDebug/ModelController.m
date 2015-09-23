//
//  ModelController.m
//  iosDebug
//
//  Created by Jaideep Shah on 9/16/15.
//  Copyright (c) 2015 Jaideep Shah. All rights reserved.
//

#import "ModelController.h"
#import "PublisherDataViewController.h"
#import "SubscriberDataViewController.h"

#define PUBLISHER_INDEX     0

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */
static NSString* const kApiKey = @"100";
// Replace with your generated session ID
static NSString* const kSessionId = @"2_MX4xMDB-fjE0NDI0MzUzMDY3MjV-Q3FqYVhGVjRDUmR0WnVwT3I3alpWV0RSfn4";
// Replace with your generated token
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0xMDAmc2RrX3ZlcnNpb249dGJwaHAtdjAuOTEuMjAxMS0wNy0wNSZzaWc9YjQyZjYwMDUzZGUzMjMxZTE4MTY5ZDY2M2UxNzJmMjRiNWNkZTBmMjpzZXNzaW9uX2lkPTJfTVg0eE1EQi1makUwTkRJME16VXpNRFkzTWpWLVEzRnFZVmhHVmpSRFVtUjBXblZ3VDNJM2FscFdWMFJTZm40JmNyZWF0ZV90aW1lPTE0NDI0MzQwMTQmcm9sZT1tb2RlcmF0b3Imbm9uY2U9MTQ0MjQzNDAxNC43ODk2MTA1NDI1MTIxNyZleHBpcmVfdGltZT0xNDQ1MDI2MDE0";


@interface ModelController () <OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate>
{

    NSMutableDictionary *allSubscribers;
    NSMutableArray *allConnectionsIds;
    NSMutableArray *backgroundConnectedStreams;
    OTSession* _session;
    NSUInteger currentIndex;  // 0 is pub , 1 to n sub
    
}

@property (nonatomic) OTPublisher * publisher;
@property (nonatomic) OTSubscriber * currentSubscriber;
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation ModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
        

        allSubscribers = [[NSMutableDictionary alloc] init];
        allConnectionsIds = [[NSMutableArray alloc] init];
        backgroundConnectedStreams = [[NSMutableArray alloc] init];

        // application background/foreground monitoring for publish/subscribe video
        // toggling
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(enteringBackgroundMode:)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(leavingBackgroundMode:)
         name:UIApplicationDidBecomeActiveNotification
         object:nil];

        
        _session = [[OTSession alloc] initWithApiKey:kApiKey
                                           sessionId:kSessionId
                                            delegate:self];
        OTError *error = nil;
        
        [_session connectWithToken:kToken error:&error];
        if (error)
        {
            [self showAlert:[error localizedDescription]];
        }

        
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    currentIndex = index;
    
    if(currentIndex == PUBLISHER_INDEX) {
        // Create a new view controller and pass suitable data.
        PublisherDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"PublisherDataViewController"];
        dataViewController.dataObject = self.pageData[index];
        self.delegate = dataViewController;
        _currentSubscriber = nil;
        [self didReceiveVideo];
        return dataViewController;
    } else  if (currentIndex > PUBLISHER_INDEX && currentIndex <= allSubscribers.count) {
        // Create a new view controller and pass suitable data.
        SubscriberDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"SubscriberDataViewController"];
        dataViewController.dataObject = self.pageData[index];
        self.delegate = dataViewController;

        NSString *connectionId = allConnectionsIds[currentIndex-1];
        self.currentSubscriber = allSubscribers[connectionId];
        [self didReceiveVideo];
        return dataViewController;
    }
    return nil;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    if(currentIndex == PUBLISHER_INDEX)
    {
        return [self.pageData indexOfObject:((PublisherDataViewController *)viewController).dataObject];
    } else {
        return [self.pageData indexOfObject:((SubscriberDataViewController *)viewController).dataObject];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}
#pragma mark Publishing
-(void) didReceiveVideo
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        // post a notification to the controller that video has arrived for this
        // subscriber. Useful for transitioning a "loading" UI.
        if ([self.delegate
             respondsToSelector:@selector(didReceivePublisherVideo:subscriberVideo:)])
        {
            [self.delegate didReceivePublisherVideo:self.publisher subscriberVideo:self.currentSubscriber];
        }
    });
    
}


- (void)doPublish
{
    self.publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                     name:[[UIDevice currentDevice] name]];
    
    OTError *error = nil;
    [_session publish:self.publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    

}

# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    
    // Step 2: We have successfully connected, now instantiate a publisher and
    // begin pushing A/V streams into OpenTok.
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}
- (void)session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    NSLog(@"connectionDestroyed: %@", connection);
}

- (void)session:(OTSession *)session
connectionCreated:(OTConnection *)connection
{
    NSLog(@"addConnection: %@", connection);
}
- (void)  session:(OTSession *)mySession
    streamCreated:(OTStream *)stream
{
    NSLog(@"streamCreated %@", stream.connection.connectionId);
    [self createSubscriber:stream];
}

- (void)    session:(OTSession *)session
    streamDestroyed:(OTStream *)stream
{
    NSLog(@"streamDestroyed %@", stream.connection.connectionId);
}
- (void)session:(OTSession *)session didFailWithError:(OTError *)error
{
    NSLog(@"sessionDidFail");
    [self showAlert:
     [NSString stringWithFormat:@"There was an error connecting to session %@",
      session.sessionId]];
    
}
# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    if(currentIndex == PUBLISHER_INDEX) {
        self.currentSubscriber = nil;
        [self didReceiveVideo];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{

}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self showAlert:[NSString stringWithFormat:
                     @"There was an error publishing."]];
    
}
#pragma mark OTSUbscriber delegates
- (void)createSubscriber:(OTStream *)stream
{
    
    if ([[UIApplication sharedApplication] applicationState] ==
        UIApplicationStateBackground ||
        [[UIApplication sharedApplication] applicationState] ==
        UIApplicationStateInactive)
    {
        [backgroundConnectedStreams addObject:stream];
    } else
    {
        // create subscriber
        OTSubscriber *subscriber = [[OTSubscriber alloc]
                                    initWithStream:stream delegate:self];
        
        // subscribe now
        OTError *error = nil;
        [_session subscribe:subscriber error:&error];
        if (error)
        {
            [self showAlert:[error localizedDescription]];
        }
        
    }
}

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);
    
    // create subscriber
    OTSubscriber *sub = (OTSubscriber *)subscriber;
    [allSubscribers setObject:subscriber forKey:sub.stream.connection.connectionId];
    [allConnectionsIds addObject:sub.stream.connection.connectionId];
   
    self.currentSubscriber = sub;
    [self didReceiveVideo];

}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}
#pragma mark BackGround/Foreground
- (void)enteringBackgroundMode:(NSNotification*)notification
{
//    _publisher.publishVideo = NO;
//    _currentSubscriber.subscribeToVideo = NO;
}

- (void)leavingBackgroundMode:(NSNotification*)notification
{
}
#pragma mark UIAlert
- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}

@end
