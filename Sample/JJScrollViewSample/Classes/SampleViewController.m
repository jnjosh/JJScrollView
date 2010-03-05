//
//  SampleViewController.m
//  JJScrollViewSample
//
//  Created by Joshua Johnson on 3/5/10.
//  Copyright 2010 jnjosh.com. All rights reserved.
//

#import "SampleViewController.h"


@implementation SampleViewController

-(void)setupViewColor:(UIColor *)color andText:(NSString *)string forIndex:(int)index {
	sheetIndex = index;
	
	[[self view] setBackgroundColor:color];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
	[label setText:string];
	[label setBackgroundColor:[UIColor clearColor]];
	[[self view] addSubview:label];
	[label release];
	
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
	[btn setTitle:@"Turn background white" forState:UIControlStateNormal];
	[btn setBackgroundColor:[UIColor darkGrayColor]];
	[btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:btn];
	[btn release];
}

-(void)testClick:(id)sender {
	[[self view] setBackgroundColor:[UIColor whiteColor]];
}

@end
