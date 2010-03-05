//
//  JJScrollView.m
//  jnjosh.com
//
//  Created by Joshua Johnson on 11/28/09.
//  Copyright 2009 jnjosh.com. All rights reserved.
//

#import "JJScrollView.h"

#define DEFAULT_MAX_VIEWS 3
#define DEFAULT_VIEW_WIDTH 320
#define DEFAULT_VIEW_HEIGHT 480
#define PUSHED_VIEW_POSITION 3 * DEFAULT_VIEW_WIDTH

@interface JJScrollView (Private)
-(void)moveCurrentViewToCenter:(BOOL)isFeature;
-(void)removeNonCurrentViews;
@end

@implementation JJScrollView (Private)

-(void)removeNonCurrentViews {
	for (UIView *view in [scrollView subviews]) {
		if (view.frame.origin.x != DEFAULT_VIEW_WIDTH) {
			[view removeFromSuperview];
		}
	}
}


/*
 * Reposition everything so current view is center
 */ 
-(void)moveCurrentViewToCenter:(BOOL)isFeature {
	// move properly
	NSLog(@"subviews: %d", [scrollView.subviews count]);
	CGFloat moveDistance = [scrollView.subviews count] > 2 ? DEFAULT_VIEW_WIDTH * 2 : 0;
	NSLog(@"movedistance: %f", moveDistance);
	
	for (int i = 0; i<[scrollView.subviews count]; i++) {
		UIView *thisView = [scrollView.subviews objectAtIndex:i];
		CGRect tmpFrame = CGRectMake(thisView.frame.origin.x - moveDistance, thisView.frame.origin.y, thisView.frame.size.width, thisView.frame.size.height);
		[thisView setFrame:tmpFrame];
	}
	
	// reset to 320
	CGRect homeViewRect = CGRectMake(isFeatureView ? 0 : DEFAULT_VIEW_WIDTH, scrollView.frame.origin.x, scrollView.frame.size.width, scrollView.frame.size.height);
	[scrollView setContentOffset:homeViewRect.origin];
	
	// clear out old
	[self removeNonCurrentViews];
	
	// load sides
	if (isFeatureView) {
		[self removeNonCurrentViews];
		[(UIView *)[scrollView.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, DEFAULT_VIEW_WIDTH, DEFAULT_VIEW_HEIGHT)];
		[scrollView setContentSize:CGSizeMake(DEFAULT_VIEW_WIDTH, DEFAULT_VIEW_HEIGHT)];
	} else {	
		[scrollView setContentSize:CGSizeMake(DEFAULT_VIEW_WIDTH * 3, DEFAULT_VIEW_HEIGHT)];
		[self scrollViewDidEndDecelerating:scrollView];
	}
	
}


@end


@implementation JJScrollView

#pragma mark 
#pragma mark properties
@synthesize delegate;

#pragma mark 
#pragma mark setup / teardown

- (void)dealloc {
	[scrollView release];
	[loadedViewControllers release];
    [super dealloc];
}

#pragma mark 
#pragma mark view handling

-(void)viewDidLoad {
	if (scrollView == nil) {
		scrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] retain];
		loadedViewControllers = [[[NSMutableArray alloc] init] retain];
	}

	// setup scrollView properties
	[scrollView setPagingEnabled:YES];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[scrollView setScrollsToTop:NO];
	[scrollView setBounces:YES];
	[scrollView setDirectionalLockEnabled:YES];
	[scrollView setDelaysContentTouches:YES];
	[scrollView setDelegate:self];
	[scrollView setContentOffset:CGPointMake(DEFAULT_VIEW_WIDTH, 0) animated:NO];
	[self.view addSubview:scrollView];
	
	previousPage = 1;
}

#pragma mark 
#pragma mark UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
	// remove old views
	UIView *retView = nil;
	for (UIView *view in [aScrollView subviews]) {
		CGRect viewFrame = [view frame];
		if (viewFrame.origin.x == aScrollView.contentOffset.x) {
			retView = view;
		} else {
			[view removeFromSuperview];
		}
	}
	
	// clear out unused controllers
	NSArray *loadedVcs = (NSArray *)[loadedViewControllers copy];
	for (UIViewController *vc in loadedVcs) {
		if (vc.view.frame.origin.x != aScrollView.contentOffset.x) {
			[loadedViewControllers removeObject:vc];
		}
	}
	[loadedVcs release];

	// tell delegate we are on this page
	UIViewController *currentVc = [loadedViewControllers objectAtIndex:0];
	[delegate scollView:self selectedViewContollerChanged:currentVc];
	
	// move current frame
	CGRect rf = CGRectMake(DEFAULT_VIEW_WIDTH, retView.frame.origin.y, retView.frame.size.width, retView.frame.size.height);
	[retView setFrame:rf];
	[aScrollView scrollRectToVisible:rf animated:NO];
	[aScrollView setContentOffset:rf.origin];
	
	// uiviewcontroller
	if ([delegate conformsToProtocol:@protocol(JJScrollViewDelegateProtocol)]) {
		// add before
		UIViewController *newVc = [delegate scrollView:self needsPrevViewControllerForPage:1];
		if (newVc != nil) {
			CGRect leftf = CGRectMake(0, retView.frame.origin.y, retView.frame.size.width, retView.frame.size.height);
			UIView *v1 = [newVc view];
			[v1 setFrame:leftf];
			[loadedViewControllers addObject:newVc];
			[aScrollView addSubview:v1];
		}
		
		// add after
		newVc = [delegate scrollView:self needsNextViewControllerForPage:1];
		if (newVc != nil) {
			CGRect rightf = CGRectMake(DEFAULT_VIEW_WIDTH * 2, retView.frame.origin.y, retView.frame.size.width, retView.frame.size.height);
			UIView *v2 = [newVc view];
			[v2 setFrame:rightf];
			[loadedViewControllers addObject:newVc];
			[aScrollView addSubview:v2];
		}
	}
}

#pragma mark 
#pragma mark instance methods
/*
 * add initial set of view controllers
 */ 
-(void)addInitialViewControllers:(NSArray *)viewControllers {
	int valueForX = 0;
	
	// add to array and scroll view
	if ([viewControllers count] > 0) {
		// add items to view
		for (UIViewController *vc in viewControllers) {
			[[vc view] setFrame:CGRectMake(valueForX, 0, vc.view.frame.size.width, vc.view.frame.size.height)];
			[scrollView addSubview:[vc view]];
			[loadedViewControllers addObject:[vc retain]];
			valueForX += DEFAULT_VIEW_WIDTH;
		}
		
		// scroll to middle item if possible
		[scrollView setContentSize:CGSizeMake(DEFAULT_VIEW_WIDTH * [loadedViewControllers count], self.view.frame.size.height)];
		[scrollView scrollRectToVisible:CGRectMake(DEFAULT_VIEW_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height) animated:NO];
	}
}



-(void)pushNewViewController:(UIViewController *)viewController isFeatureView:(BOOL)isFeature {
	// add controller to controller list
	[loadedViewControllers addObject:viewController];
	
	CGFloat pushPoint = [scrollView.subviews count] > 1 ? PUSHED_VIEW_POSITION : DEFAULT_VIEW_WIDTH;
	
	// add new view at 960
	CGRect newViewRect = CGRectMake(pushPoint, scrollView.frame.origin.x, scrollView.frame.size.width, scrollView.frame.size.height);
	[viewController.view setFrame:newViewRect];
	[scrollView addSubview:viewController.view];
	
	[scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.x, DEFAULT_VIEW_WIDTH - 1, DEFAULT_VIEW_HEIGHT) animated:NO];
	isFeatureView = isFeature;
	
	CGPoint homeOrigin = CGPointMake(pushPoint, scrollView.frame.origin.y);
	[UIView beginAnimations:@"viewAnimation" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveCurrentViewToCenter:)];
	[scrollView setContentOffset:homeOrigin];
	[UIView commitAnimations];
}

-(UIView *)currentView {
	for (UIView *v in scrollView.subviews) {
		if (v.frame.origin.x == DEFAULT_VIEW_WIDTH) {
			return v;
		}
	}
	return nil;
}


-(UIViewController *)viewControllerForViewOnPage:(int)page {
	CGFloat pageLeft = DEFAULT_VIEW_WIDTH * page;
	//NSLog(@"looking for vc on page %d at x = %f", page, pageLeft);
	
	for (UIViewController *vc in loadedViewControllers) {
		//NSLog(@"found view at %d", vc.view.frame.origin.x);
		if (vc.view.frame.origin.x == pageLeft) {
			//NSLog(@"found view to remove %d", vc.view.frame.origin.x);
			return vc;
		}
	}
	return nil;
}

-(void)logStatus {
	NSLog(@"current scroll position: %f", scrollView.contentOffset.x);
	NSLog(@"current scroll size: (%f, %f)", scrollView.contentSize.width, scrollView.contentSize.height);
	for (UIView *v in scrollView.subviews) {
		NSLog(@"subview at x: %f", v.frame.origin.x);

	}
}

#pragma mark 
#pragma mark other UIViewController methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
