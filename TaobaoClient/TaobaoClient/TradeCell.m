//
//  TradeCell.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-21.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TradeCell.h"


@implementation TradeCell

@synthesize tradeImg;
@synthesize tradeName;
@synthesize tradeStatus;
@synthesize tradeCreate;
@synthesize tradePrice;


- (void)dealloc
{
    [tradeImg release];
    [tradeName release];
    [tradePrice release];
    [tradeStatus release];
    [tradeCreate release];
    [super dealloc];
}

@end
