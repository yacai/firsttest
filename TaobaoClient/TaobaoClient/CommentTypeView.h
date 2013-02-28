//
//  CommentView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "TaobaoClientAppDelegate.h"
#import "Utility.h"
#import "CommentlistView.h"

@interface CommentTypeView : UIViewController 
<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{
    IBOutlet UITableView *tableView;
    CommentModel *commModel;
    NSString *currentElement;
    NSMutableArray *datalist;
    NSMutableArray *goodlist;
    NSMutableArray *neutrallist;
    NSMutableArray *badlist;
    NSString *commentType;//选中的类型
    
    IBOutlet UIView *overlayer;     //加载时候的等待
    BOOL isloading;                 //是否正在加载
    int count;                      //加载时间不超过10s
}

@property(nonatomic,retain)IBOutlet UIView *overlayer;
@property(nonatomic)BOOL isloading;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)CommentModel *commModel;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)NSMutableArray *datalist;
@property(nonatomic,retain)NSMutableArray *goodlist;
@property(nonatomic,retain)NSMutableArray *neutrallist;
@property(nonatomic,retain)NSMutableArray *badlist;
@property(nonatomic,retain)NSString *commentType;
@end
