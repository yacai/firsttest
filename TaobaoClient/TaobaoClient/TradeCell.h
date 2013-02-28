//
//  TradeCell.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-21.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TradeCell : UITableViewCell {
    IBOutlet UIImageView *tradeImg;
    IBOutlet UILabel *tradeName;
    IBOutlet UILabel *tradeStatus;
    IBOutlet UILabel *tradePrice;
    IBOutlet UILabel *tradeCreate;
}
@property(nonatomic,retain)IBOutlet UIImageView *tradeImg;
@property(nonatomic,retain)IBOutlet UILabel *tradeName;
@property(nonatomic,retain)IBOutlet UILabel *tradeStatus;
@property(nonatomic,retain)IBOutlet UILabel *tradePrice;
@property(nonatomic,retain)IBOutlet UILabel *tradeCreate;
@end
