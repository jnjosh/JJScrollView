//
//  JJScrollViewSampleViewController.m
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright jnjosh.com 2010. All rights reserved.
//

#import "JJScrollViewSampleViewController.h"
#import "JJScrollView.h"
#import "SampleViewController.h"

@implementation JJScrollViewSampleViewController

#pragma mark synthesize
@synthesize infiniteScrollView;

#pragma mark 
#pragma mark basics

- (void)dealloc {
	[infiniteScrollView release];
	[viewItems release];
	[viewColors release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	viewItems = [[NSArray alloc] initWithObjects:@"View 1", @"View 2", @"View 3", @"View 4", nil];
	viewColors = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor], nil];
	
	[infiniteScrollView setDelegate:self];
	[infiniteScrollView addInitialViewControllers:[NSArray arrayWithObjects:
												   [self viewControllerForPage:1],
												   [self viewControllerForPage:2],
												   [self viewControllerForPage:3], nil]];
	currentPage = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 
#pragma mark view loading

/**
 * load a new view controller from the array 
 */
-(UIViewController *)viewControllerForPage:(int)page {
	SampleViewController *sampleView = [[SampleViewController alloc] init];
	[sampleView setupViewColor:[viewColors objectAtIndex:page] andText:[viewItems objectAtIndex:page] forIndex:page];
	return [sampleView autorelease];
}

#pragma mark 
#pragma mark JJScrollViewDelegate

-(UIViewController *)scrollView:(JJScrollView *)theScrollView needsNextViewControllerForPage:(int)page { 
	int pageIndex = currentPage == ([viewItems count] - 1) ? 0 : currentPage + 1;
	return [self viewControllerForPage:pageIndex]; 
}

-(UIViewController *)scrollView:(JJScrollView *)theScrollView needsPrevViewControllerForPage:(int)page { 
	int pageIndex = currentPage == 0 ? [viewItems count] - 1 : currentPage - 1;  
	return [self viewControllerForPage:pageIndex]; 
}

-(void)scollView:(JJScrollView *)theScrollView selectedViewContollerChanged:(UIViewController *)selectedViewController {
	SampleViewController *selected = (SampleViewController *)selectedViewController;
	currentPage = [[selected valueForKey:@"sheetIndex"] intValue];
	NSLog(@"currentPage = %d", currentPage);
}


@end
