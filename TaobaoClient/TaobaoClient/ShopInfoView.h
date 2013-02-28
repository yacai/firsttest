//
//  ShopInfoView.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-25.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface ShopInfoView : UIViewController {
    IBOutlet UILabel *shopNum;
    IBOutlet UILabel *shoptitle;
    IBOutlet UILabel *shopScore;
    IBOutlet UILabel *itemScore;
    IBOutlet UILabel *serviceScore;
    IBOutlet UILabel *sendScore;
    IBOutlet UILabel *shopCreate;
    IBOutlet UIScrollView *scrollView;
    
    ShopModel *shopModel;
}

@property(nonatomic,retain)ShopModel *shopModel;
@property(nonatomic,retain)IBOutlet UILabel *shopNum;
@property(nonatomic,retain)IBOutlet UILabel *shoptitle;
@property(nonatomic,retain)IBOutlet UILabel *shopScore;
@property(nonatomic,retain)IBOutlet UILabel *itemScore;
@property(nonatomic,retain)IBOutlet UILabel *serviceScore;
@property(nonatomic,retain)IBOutlet UILabel *sendScore;
@property(nonatomic,retain)IBOutlet UILabel *shopCreate;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;

@end
