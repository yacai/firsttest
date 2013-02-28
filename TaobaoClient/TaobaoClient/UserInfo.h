//
//  UserInfo.h
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TaobaoClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "UserInfoModel.h"

@interface UserInfo : UIViewController 
<UIWebViewDelegate,NSXMLParserDelegate>{
    UIWebView *webView;
    UISearchBar *searchBar;
    UIScrollView *scrollView;
    UILabel *frontLabel;
    UIImageView *frontImage;
    NSString *currentElement;
    UserInfoModel *userInfoModel;
    
    IBOutlet UILabel *nick;
    IBOutlet UILabel *sex;
    IBOutlet UILabel *location;
    IBOutlet UILabel *created;
    IBOutlet UILabel *last_visit;
    IBOutlet UILabel *birthday;
    IBOutlet UILabel *status;
    IBOutlet UILabel *email;
}

@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,retain)IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UILabel *frontLabel;
@property(nonatomic,retain)IBOutlet UIImageView *frontImage;
@property(nonatomic,retain)NSString *currentElement;
@property(nonatomic,retain)UserInfoModel *userInfoModel;

@property(nonatomic,retain)IBOutlet UILabel *nick;
@property(nonatomic,retain)IBOutlet UILabel *sex;
@property(nonatomic,retain)IBOutlet UILabel *location;
@property(nonatomic,retain)IBOutlet UILabel *created;
@property(nonatomic,retain)IBOutlet UILabel *last_visit;
@property(nonatomic,retain)IBOutlet UILabel *birthday;
@property(nonatomic,retain)IBOutlet UILabel *status;
@property(nonatomic,retain)IBOutlet UILabel *email;

@property(nonatomic,retain)IBOutlet UIImageView *photo;
@property(nonatomic,retain)IBOutlet UILabel *creditDegree;
@property(nonatomic,retain)IBOutlet UILabel *goodCommentScore;
@property(nonatomic,retain)IBOutlet UILabel *totalCommentScore;
@property(nonatomic,retain)IBOutlet UILabel *isPassed;
@property(nonatomic,retain)IBOutlet UILabel *payAccount;


-(IBAction)searchAction:(id)sender;
@end
