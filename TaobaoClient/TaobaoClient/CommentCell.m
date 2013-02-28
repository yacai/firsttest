//
//  CommentCell.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CommentCell.h"


@implementation CommentCell

@synthesize item_title;
@synthesize item_create;
@synthesize item_content;

- (void)dealloc
{
    [item_create release];
    [item_content release];
    [item_title release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
