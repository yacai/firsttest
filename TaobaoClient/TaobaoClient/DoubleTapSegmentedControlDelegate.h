//
//  DoubleTapSegmentedControlDelegate.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

@class DoubleTapSegmentedControl;

#import <Foundation/Foundation.h>

@protocol DoubleTapSegmentedControlDelegate <NSObject>
- (void) performSegmentAction: (DoubleTapSegmentedControl *) sender;
@end
