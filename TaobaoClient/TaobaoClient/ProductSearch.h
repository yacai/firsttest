//
//  ProductSearch.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemProductModel.h"
#import "Utility.h"
#import "Constants.h"
#import "ProductInfo.h"
#import "ProductCell.h"
#import "shopSearchView.h"

@interface ProductSearch : UIViewController
<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{
    UISearchBar *searchBar;
    NSString *currentmElement;      //当前的遍历节点
    ItemProductModel *itemProModel; //需要单个加载的商品对象
    UITableView *tableView;     
    NSMutableArray *itemProlist;    //搜索到的商品列表
    UIView *overlayer;
    int count;                      //等待的时间不超过10s
    BOOL isloading;                 //是否正在加载数据
    BOOL isSearch;                  //是否是搜索操作
    
    IBOutlet UIView *detailView;    //详细搜索视图
    IBOutlet UISwitch *goodFirst;   //货到付款
    IBOutlet UISwitch *taobaoItem;  //商城商品
    IBOutlet UISwitch *wangwangOnline;//旺旺在线
    IBOutlet UISwitch *securityItem;//正品保障
    IBOutlet UISwitch *noFake;      //假一赔三
    IBOutlet UISwitch *noPostfee;   //免邮
    NSMutableArray *detaillist;     //商品搜索的详细筛选条件
    
}

@property(nonatomic,retain)IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)ItemProductModel *itemProModel;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *itemProlist;
@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic)BOOL isloading;
@property(nonatomic)BOOL isSearch;

@property(nonatomic,retain)IBOutlet UIView *detailView;
@property(nonatomic,retain)IBOutlet UISwitch *goodFirst;
@property(nonatomic,retain)IBOutlet UISwitch *taobaoItem;
@property(nonatomic,retain)IBOutlet UISwitch *wangwangOnline;
@property(nonatomic,retain)IBOutlet UISwitch *securityItem;
@property(nonatomic,retain)IBOutlet UISwitch *noFake;
@property(nonatomic,retain)IBOutlet UISwitch *noPostfee;
@property(nonatomic,retain)NSMutableArray *defaillist;

-(IBAction)detailSearch:(id)sender;
-(IBAction)codAction:(id)sender;
-(IBAction)mallAction:(id)sender;
-(IBAction)wangwangAction:(id)sender;
-(IBAction)securityActoin:(id)sender;
-(IBAction)promotedAction:(id)sender;
-(IBAction)postfeeAction:(id)sender;
@end
