//
//  ProductCell.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "ProductCell.h"


@implementation ProductCell

@synthesize proImage;
@synthesize scrImage;
@synthesize title;
@synthesize price;

- (void)dealloc
{
    [proImage release];
    [scrImage release];
    [title release];
    [price release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
