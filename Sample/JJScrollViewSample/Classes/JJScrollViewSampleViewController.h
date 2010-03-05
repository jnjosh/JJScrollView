//
//  JJScrollViewSampleViewController.h
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright jnjosh.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJScrollView.h"

@interface JJScrollViewSampleViewController : UIViewController <JJScrollViewDelegateProtocol> {
	IBOutlet JJScrollView *infiniteScrollView;
	
	NSArray *viewItems;
	NSArray *viewColors;
	int currentPage;
}

@property (nonatomic, retain) IBOutlet JJScrollView *infiniteScrollView;

-(UIViewController *)viewControllerForPage:(int)page;

@end

