//
//  SettingView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-25.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "SettingView.h"


@implementation SettingView

@synthesize textView;
@synthesize soundSetting;

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
    [textView release];
    [soundSetting release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)settingAction:(id)sender
{
     TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(self.soundSetting.on)
    {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"YES" forKey:@"isLoadingSound"];
        appDelegate.isLoadingSound=YES;
    }
    else
    {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"NO" forKey:@"isLoadingSound"];
        appDelegate.isLoadingSound=NO;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.textView.editable=NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.soundSetting=nil;
    self.textView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
