//
//  DoubleTapSegmentedControl.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "DoubleTapSegmentedControl.h"


@implementation DoubleTapSegmentedControl
@synthesize delegate;

// Catch touches and trigger the delegate
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if (self.delegate) [self.delegate performSegmentAction:self];
}

@end
