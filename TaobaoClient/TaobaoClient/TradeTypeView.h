//
//  TradeTypeView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-22.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradelistView.h"

@interface TradeTypeView : UIViewController 
<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tradeTypes;
    IBOutlet UITableView *tableView;
    NSMutableArray *tradelist;
    NSMutableArray *paylist;        //等待付款的订单列表
    NSMutableArray *deliverlist;    //等待发货的订单的列表
    NSMutableArray *confirmlist;    //等待确认收货订单的列表
    NSMutableArray *closelist;      //关闭交易的订单列表
    
    IBOutlet UIView *overlayer;     //加载时候的等待
    BOOL isloading;                 //是否正在加载
    int count;                      //加载时间不超过10s
}

@property(nonatomic)BOOL isloading;
@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic,retain)NSMutableArray *tradeTypes;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *tradelist;
@property(nonatomic,retain)NSMutableArray *paylist;
@property(nonatomic,retain)NSMutableArray *deliverlist;
@property(nonatomic,retain)NSMutableArray *confirmlist;
@property(nonatomic,retain)NSMutableArray *closelist;
@end
