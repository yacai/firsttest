//
//  TaobaoClientAppDelegate.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Utility.h"

@class TaobaoClientViewController;

@interface TaobaoClientAppDelegate : NSObject <UIApplicationDelegate> {
    AVAudioPlayer *ripplePlayer;//水波声音
    AVAudioPlayer *pagePlayer;  //翻页声音
    AVAudioPlayer *btnPlayer;   //按钮声音
    AVAudioPlayer *alertPlayer; //警告声音
    BOOL isLoadingSound;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic)BOOL isLoadingSound;//是否开启按钮音效,默认开启
@property(nonatomic,retain) NSString *sessionKey;
@property(nonatomic,retain)NSString *nick;
@property(nonatomic,retain)NSMutableDictionary *kuaidiParams;
@property(nonatomic,retain) AVAudioPlayer *ripplePlayer;
@property(nonatomic,retain) AVAudioPlayer *pagePlayer;
@property(nonatomic,retain) AVAudioPlayer *btnPlayer;
@property(nonatomic,retain) AVAudioPlayer *alertPlayer;

-(void)loadRippleSound:(NSInteger)index;
-(void)loadPageSound:(NSInteger)index;
-(void)loadButtonSound:(NSInteger)index;
-(void)loadAlertSound:(NSInteger)index;
@end
