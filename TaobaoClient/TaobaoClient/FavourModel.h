//
//  FavourModel.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchModel.h"

@interface FavourModel : NSObject {
    
}

@property(nonatomic,retain)NSString *total_result;
@property(nonatomic,retain)NSMutableArray *searchlist;
@end
