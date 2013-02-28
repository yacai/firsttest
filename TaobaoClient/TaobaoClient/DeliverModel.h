//
//  DeliverModel.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliverTraceModel.h"

@interface DeliverModel : NSObject {
    
}
@property(nonatomic,retain)NSString *out_sid;
@property(nonatomic,retain)NSString *company_name;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSMutableArray *delTraceModel;
@end
