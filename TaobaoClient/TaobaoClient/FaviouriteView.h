//
//  FaviouriteView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavourModel.h"
#import "ProductInfo.h"
#import "Utility.h"
#import "ItemProductModel.h"
#import "DoubleTapSegmentedControl.h"
#import "TaobaoClientAppDelegate.h"
#import "SearchModel.h"
#import "ShopInfoView.h"
#import "ShopModel.h"

@interface FaviouriteView : UIViewController 
<UITableViewDataSource,UITableViewDelegate
,NSXMLParserDelegate,DoubleTapSegmentedControlDelegate>{
    IBOutlet UITableView *tableView;
    
    SearchModel *searchModel;
    FavourModel *favModel;
    
    ProductInfo *proInfo;
    ItemProductModel *itemModel;
    NSString *rootElement;  
    NSString *currentElement;
    
    BOOL  isItemFavourite;//是否加载的是宝贝收藏视图
    
    //分页变量
    NSInteger maxCount;
    int currentPage;
    int maxPage;
    
    IBOutlet UIView *overlayer;     //加载时候的等待
    BOOL isloading;                 //是否正在加载
    int count;                      //加载时间不超过10s
    
    ShopModel *shopModel;           //加载店铺的信息
}

@property(nonatomic,retain)ShopModel *shopModel;
@property(nonatomic,retain)SearchModel *searchModel;
@property(nonatomic,retain)NSString *rootElement;
@property(nonatomic)NSInteger maxCount;
@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic)BOOL isloading;
@property(nonatomic)BOOL isItemFavourite;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)FavourModel *favModel;
@property(nonatomic,retain)ProductInfo *proInfo;
@property(nonatomic,retain)ItemProductModel *itemModel;
@property(nonatomic,retain)NSString *currentElement;
@end
