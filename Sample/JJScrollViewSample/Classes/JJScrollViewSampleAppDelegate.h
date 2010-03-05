//
//  JJScrollViewSampleAppDelegate.h
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright jnjosh.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJScrollViewSampleViewController;

@interface JJScrollViewSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    JJScrollViewSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet JJScrollViewSampleViewController *viewController;

@end

