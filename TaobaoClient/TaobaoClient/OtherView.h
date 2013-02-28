//
//  OtherView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-21.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeTypeView.h"
#import "TradeInfoView.h"
#import "TradeModel.h"
#import "TaobaoClientAppDelegate.h"
#import "FavourModel.h"
#import "FaviouriteView.h"
#import "DeliverSearchView.h"
#import "CommentTypeView.h"
#import "CommentModel.h"
#import "SearchModel.h"

@interface OtherView : UIViewController 
<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{
    NSMutableArray *functionlist;
    IBOutlet UITableView *tableView;
    
    NSString *rootElement;          //对象的根节点
    NSString *currentElement;       //当前的节点
    
    TradeModel *tradeModel;         //交易订单对象
    NSMutableArray *datalist;      //数据列表
    NSMutableArray *paylist;        //等待付款的订单列表
    NSMutableArray *deliverlist;    //等待发货的订单的列表
    NSMutableArray *confirmlist;    //等待确认收货订单的列表
    NSMutableArray *closelist;      //关闭交易的订单列表
    
    SearchModel *searchModel;        
    FavourModel *itemModel;          //我的宝贝收藏对象
    FavourModel *shopModel;         //我的店铺收藏对象
    
    BOOL isItemUpdate;              //默认是商品收藏个数更新
    
    CommentModel *commModel;        //评论对象
    NSMutableArray *commlist;       //所有的评论列表
    NSMutableArray *googlist;       //好评的列表
    NSMutableArray *neutrallist;    //中评的列表
    NSMutableArray *badlist;        //差评的列表
    
    IBOutlet UIView *overlayer;     //加载时候的等待
    BOOL isloading;                 //是否正在加载
    int count;                      //加载时间不超过10s
}

@property(nonatomic,retain)SearchModel *searchModel;
@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic)BOOL isloading;
@property(nonatomic)BOOL isItemUpdate;
@property(nonatomic,retain)FavourModel*itemModel;
@property(nonatomic,retain)FavourModel *shopModel;
@property(nonatomic,retain)NSMutableArray *functionlist;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)TradeModel *tradeModel;
@property(nonatomic,retain)NSMutableArray *datalist;
@property(nonatomic,retain)NSMutableArray *paylist;
@property(nonatomic,retain)NSMutableArray *deliverlist;
@property(nonatomic,retain)NSMutableArray *confirmlist;
@property(nonatomic,retain)NSMutableArray *closelist;
@property(nonatomic,retain)NSString *rootElement;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)CommentModel *commModel;
@property(nonatomic,retain)NSMutableArray *commlist;
@property(nonatomic,retain)NSMutableArray *googlist;
@property(nonatomic,retain)NSMutableArray *neutrallist;
@property(nonatomic,retain)NSMutableArray *badlist;
@end
