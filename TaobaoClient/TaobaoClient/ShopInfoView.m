//
//  ShopInfoView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-25.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "ShopInfoView.h"


@implementation ShopInfoView

@synthesize shopModel;
@synthesize shopNum;
@synthesize shoptitle;
@synthesize shopScore;
@synthesize shopCreate;
@synthesize itemScore;
@synthesize serviceScore;
@synthesize sendScore;
@synthesize scrollView;

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
    [shopModel release];
    [scrollView release];
    [shopNum release];
    [shopCreate release];
    [shoptitle release];
    [shopScore release];
    [itemScore release];
    [serviceScore release];
    [sendScore release];
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
    
    self.shopNum.text=self.shopModel.shopNum;
    self.shoptitle.text=self.shopModel.shoptitle;
    self.shopCreate.text=self.shopModel.shopCreate;
    self.itemScore.text=self.shopModel.itemScore;
    self.serviceScore.text=self.shopModel.serviceScore;
    self.sendScore.text=self.shopModel.sendScore;

    CGSize newSize=CGSizeMake(320.0f, 490.0f);
    self.scrollView.contentSize=newSize;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.shopNum=nil;
    self.shoptitle=nil;
    self.shopCreate=nil;
    self.shopScore=nil;
    self.itemScore=nil;
    self.serviceScore=nil;
    self.sendScore=nil;
    self.scrollView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
