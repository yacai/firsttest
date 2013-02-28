//
//  CommentInfoView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CommentInfoView.h"


@implementation CommentInfoView

@synthesize scrollView;
@synthesize commModel;
@synthesize content;
@synthesize created;
@synthesize item_price;
@synthesize item_title;
@synthesize nick;
@synthesize rated_nick;
@synthesize result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [content release];
    [created release];
    [item_price release];
    [item_title release];
    [nick release];
    [result release];
    [rated_nick release];
    [scrollView release];
    [commModel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize newSize=CGSizeMake(320.0f, 667.0f);
    self.scrollView.contentSize=newSize;
    self.item_title.text=self.commModel.item_title;
    self.content.text=self.commModel.content;
    self.item_price.text=self.commModel.item_price;
    self.nick.text=self.commModel.nick;
    self.rated_nick.text=self.commModel.rated_nick;
    self.result.text=self.commModel.result;
    self.created.text=self.commModel.created;
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    self.content=nil;
    self.created=nil;
    self.item_price=nil;
    self.item_title=nil;
    self.nick=nil;
    self.result=nil;
    self.rated_nick=nil;
    self.scrollView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
