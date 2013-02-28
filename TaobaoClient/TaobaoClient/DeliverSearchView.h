//
//  DeliverSearchView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "TaobaoClientAppDelegate.h"
#import "DeliverModel.h"
#import "CompanyView.h"
#import "KuaiDi100Model.h"

@interface DeliverSearchView : UIViewController
<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tableView;
    IBOutlet UIScrollView *scrollView;
    BOOL isloading;         //是否正在加载
    int count;              //等待时间不超过10s
    UIView *overlayer;
    
    NSString *currentElement;//当前的选中节点
    KuaiDi100Model  *delModel;//搜索到的物流对象
    NSMutableArray *kuaidilist;//快递列表
    IBOutlet UILabel *resultMessage;//返回的数据
}

@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UISearchBar *searchBar;
@property(nonatomic)BOOL isloading;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)KuaiDi100Model *delModel;
@property(nonatomic,retain)NSMutableArray *kuaidilist;
@property(nonatomic,retain)IBOutlet UILabel *resultMessage;

-(IBAction)searchDetail:(id)sender;
@end
