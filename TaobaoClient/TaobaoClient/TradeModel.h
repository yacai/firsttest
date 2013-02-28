//
//  TradeModel.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface TradeModel : NSObject {
    
}
@property(nonatomic,retain)UIImage *photo;
@property(nonatomic,retain)NSString *tid;
@property(nonatomic,retain)NSString *seller_nick;
@property(nonatomic,retain)NSString *buyer_nick;
@property(nonatomic,retain)NSString *created;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *post_fee;
@property(nonatomic,retain)NSString *pay_time;
@property(nonatomic,retain)NSString *pic_path;
@property(nonatomic,retain)NSString *receiver_address;
@property(nonatomic,retain)NSString *receiver_phone;
@property(nonatomic,retain)OrderModel *orderModel;
@end
