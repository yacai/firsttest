//
//  CompanyView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaobaoClientAppDelegate.h"
#import "KuaiDi100Model.h"
#import "Constants.h"

@interface CompanyView : UIViewController
<UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UIPickerView *picker;
    NSMutableArray *serlist;                      //根据输入的显示物流列表
    NSMutableArray *derlist;                      //物流公司列表
    IBOutlet UITextField *inputfield;             //输入的物流公司
}
@property(nonatomic,retain)IBOutlet UIPickerView *picker;
@property(nonatomic,retain)NSMutableArray *serlist;
@property(nonatomic,retain)NSMutableArray *derlist;
@property(nonatomic,retain)IBOutlet UITextField *inputfield;

-(IBAction)inputFinished:(id)sender;
-(IBAction)searchAction:(id)sender;
-(IBAction)showALLAction:(id)sender;
@end
