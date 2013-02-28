//
//  shopSearchView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-22.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "ShopModel.h"
#import "TaobaoClientAppDelegate.h"

@interface shopSearchView : UIViewController
<NSXMLParserDelegate>{
    NSString *currentElement;
    ShopModel *shopInfo;
    IBOutlet UILabel *shopNum;
    IBOutlet UILabel *shoptitle;
    IBOutlet UILabel *shopScore;
    IBOutlet UILabel *itemScore;
    IBOutlet UILabel *serviceScore;
    IBOutlet UILabel *sendScore;
    IBOutlet UILabel *shopCreate;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIView *overlayer;
    int count;      //加载信息的等待的时间次数
    BOOL isLoading;//是否正在等待搜索结果
    IBOutlet UIButton *addFav;
    NSString *msg;     //添加店铺出错消息
}

@property(nonatomic,retain)NSString *msg;
@property(nonatomic,retain)IBOutlet UIButton *addFav;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)ShopModel *shopInfo;
@property(nonatomic,retain)IBOutlet UILabel *shopNum;
@property(nonatomic,retain)IBOutlet UILabel *shoptitle;
@property(nonatomic,retain)IBOutlet UILabel *shopScore;
@property(nonatomic,retain)IBOutlet UILabel *itemScore;
@property(nonatomic,retain)IBOutlet UILabel *serviceScore;
@property(nonatomic,retain)IBOutlet UILabel *sendScore;
@property(nonatomic,retain)IBOutlet UILabel *shopCreate;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic)BOOL isLoading;

-(IBAction)addFavourite:(id)sender;
@end
