//
//  SampleViewController.h
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright 2010 jnjosh.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UIViewController {
	int sheetIndex;
	
}
-(void)setupViewColor:(UIColor *)color andText:(NSString *)string forIndex:(int)index;

-(void)testClick:(id)sender;
@end
