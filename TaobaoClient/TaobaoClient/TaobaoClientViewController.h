//
//  TaobaoClientViewController.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Constants.h"
#import "ItemCategoryModel.h"
#import "Productlist.h"
#import "ItemProductModel.h"
#import <QuartzCore/QuartzCore.h>
#import "DoubleTapSegmentedControlDelegate.h"
#import "DoubleTapSegmentedControl.h"

@interface TaobaoClientViewController : UIViewController 
<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,
DoubleTapSegmentedControlDelegate>{
    NSString *currentElement;
    ItemCategoryModel *itemCat;
    ItemProductModel *itemPro;
    NSMutableArray *itemCatlist;
    NSMutableArray *itemProlist;
    BOOL isLoadProlsit;         //是否是加载类别下的商品
    NSUInteger rowIndex;
    UITableView *tableView;
    UIView *overLayer;
    
    //分页变量
    NSMutableArray *currentCatlist;
    int pageSize;
    int currentPage;
    int maxPage;
}
@property(nonatomic,retain)NSMutableArray *currentCatlist;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)ItemCategoryModel *itemCat;
@property(nonatomic,retain)ItemProductModel *itemPro;
@property(nonatomic,retain)NSMutableArray *itemCatlist;
@property(nonatomic,retain)NSMutableArray *itemProlist;
@property(nonatomic)BOOL isLoadProlist;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)IBOutlet UIView *overLayer;
@end
