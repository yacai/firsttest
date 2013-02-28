//
//  SettingView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-25.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaobaoClientAppDelegate.h"

@interface SettingView : UIViewController {
    IBOutlet UISwitch *soundSetting;
    IBOutlet UITextView *textView;
}

@property(nonatomic,retain)UISwitch *soundSetting;
@property(nonatomic,retain)IBOutlet UITextView *textView;

-(IBAction)settingAction:(id)sender;
@end
