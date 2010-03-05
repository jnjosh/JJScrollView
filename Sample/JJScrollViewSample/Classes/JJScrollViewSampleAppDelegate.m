//
//  JJScrollViewSampleAppDelegate.m
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright jnjosh.com 2010. All rights reserved.
//

#import "JJScrollViewSampleAppDelegate.h"
#import "JJScrollViewSampleViewController.h"

@implementation JJScrollViewSampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
