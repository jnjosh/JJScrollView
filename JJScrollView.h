//
//  JJScrollView.h
//  jnjosh.com
//
//  Created by Joshua Johnson on 11/28/09.
//  Copyright 2009 jnjosh.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJScrollViewDelegateProtocol.h"

@interface JJScrollView : UIViewController <UIScrollViewDelegate> {	
	@protected
	id<JJScrollViewDelegateProtocol> delegate;
	
	@private
	UIScrollView *scrollView;
	NSMutableArray *loadedViewControllers;

	int previousPage;
	int currentPage;

	BOOL isFeatureView;
}

#pragma mark 
#pragma mark properties
@property (assign) id<JJScrollViewDelegateProtocol> delegate;

#pragma mark 
#pragma mark instance methods
-(void)addInitialViewControllers:(NSArray *)viewControllers;
-(void)pushNewViewController:(UIViewController *)viewController isFeatureView:(BOOL)isFeature;
-(UIViewController *)viewControllerForViewOnPage:(int)page;
-(UIView *)currentView;

-(void)logStatus;

@end



