//
//  TaobaoClientAppDelegate.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TaobaoClientAppDelegate.h"

#import "TaobaoClientViewController.h"

@implementation TaobaoClientAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

@synthesize sessionKey=_sessionKey;

@synthesize nick=_nick;

@synthesize isLoadingSound;
@synthesize kuaidiParams=_kuaidiParams;

@synthesize ripplePlayer=_ripplePlayer;
@synthesize pagePlayer=_pagePayer;
@synthesize btnPlayer=_btnPlayer;
@synthesize alertPlayer=_alertPlayer;

//0不播放，用于程序启动时缓存
//1.播放
//加载水波效果按钮声音
-(void)loadRippleSound:(NSInteger)index
{
    if(self.isLoadingSound)//开启音效
    {
        NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"rippleEffect.wav"];
        NSError *error;
        if(self.ripplePlayer==nil)
        {
            self.ripplePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //    player.numberOfLoops=-1;//无限循环
            if(self.ripplePlayer==nil)
            {
                NSLog(@"%@",error);
            }
        }
        if(index==0)
        {
            self.ripplePlayer.volume=0.0f;
        }
        else
        {
            self.ripplePlayer.volume=1.0f;
        }
        [self.ripplePlayer play];
    }
}

-(void)loadPageSound:(NSInteger)index
{
    if(self.isLoadingSound)
    {
        NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"pageEffect.wav"];
        NSError *error;
        if(self.pagePlayer==nil)
        {
            self.pagePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            //    player.numberOfLoops=-1;//无限循环
            if(pagePlayer==nil)
            {
                NSLog(@"%@",error);
            }
        }
        if(index==0)
        {
            self.pagePlayer.volume=0.0f;
        }
        else
        {
            self.pagePlayer.volume=1.0f;
        }
        [self.pagePlayer play];
    }
}

-(void)loadButtonSound:(NSInteger)index
{
    if(self.isLoadingSound)//开启音效
    {
        NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"btnEffect.wav"];
        NSError *error;
        if(self.btnPlayer==nil)
        {
            self.btnPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            //    player.numberOfLoops=-1;//无限循环
            if(self.btnPlayer==nil)
            {
                NSLog(@"%@",error);
            }
        }
        if(index==0)
        {
            self.btnPlayer.volume=0.0f;
        }
        else
        {
            self.btnPlayer.volume=1.0f;
        }
        [self.btnPlayer play];
    }
}

-(void)loadAlertSound:(NSInteger)index
{
    if(self.isLoadingSound)//开启音效
    {
        NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"alertEffect.wav"];
        NSError *error;
        if(self.alertPlayer==nil)
        {
            self.alertPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            //    player.numberOfLoops=-1;//无限循环
            if(self.alertPlayer==nil)
            {
                NSLog(@"%@",error);
            }
        }
        if(index==0)
        {
            self.alertPlayer.volume=0.0f;
        }
        else
        {
            self.alertPlayer.volume=1.0f;
        }
        [self.alertPlayer play];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *isSound=[userDefault objectForKey:@"isLoadingSound"];
    if(isSound==@"NO")
    {
        self.isLoadingSound=NO;
    }
    else
    {
        self.isLoadingSound=YES;
    }
    [self loadRippleSound:0];
    [self loadPageSound:0];
    [self loadButtonSound:0];
    [self loadAlertSound:0];
    if(![Utility connectedToNetwork])
    {
        PLAYBUTTONSOUND;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!网络连接失败！请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_ripplePlayer release];
    [_pagePayer release];
    [_kuaidiParams release];
    [_nick release];
    [_sessionKey release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
