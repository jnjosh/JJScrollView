//
//  JJScrollViewDelegateProtocol.h
//  jnjosh.com
//
//  Created by Joshua Johnson on 11/28/09.
//  Copyright 2009 jnjosh.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJScrollView;

@protocol JJScrollViewDelegateProtocol <NSObject>

@required
-(UIViewController *)scrollView:(JJScrollView *)theScrollView needsNextViewControllerForPage:(int)page;
-(UIViewController *)scrollView:(JJScrollView *)theScrollView needsPrevViewControllerForPage:(int)page;

@optional
-(BOOL)maximumNumberOfViewsInScrollView:(JJScrollView *)theScrollView; // Defaults to 3 loaded if not implemented
-(void)scollView:(JJScrollView *)theScrollView selectedViewContollerChanged:(UIViewController *)selectedViewController;
@end
