//
//  ProductCell.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCell : UITableViewCell {
    UIImageView *proImage;
    UIImageView *scrImage;
    UILabel *title;
    UILabel *price;

}

@property(nonatomic,retain)IBOutlet UIImageView *proImage;
@property(nonatomic,retain)IBOutlet UIImageView *scrImage;
@property(nonatomic,retain)IBOutlet UILabel *title;
@property(nonatomic,retain)IBOutlet UILabel *price;

@end
