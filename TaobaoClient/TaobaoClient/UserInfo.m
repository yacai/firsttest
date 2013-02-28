//
//  UserInfo.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//获取SessionKey时的算法有待改进

#import "UserInfo.h"


@implementation UserInfo

@synthesize webView;
@synthesize scrollView;
@synthesize searchBar;
@synthesize frontImage;
@synthesize frontLabel;
@synthesize currentElement;
@synthesize userInfoModel;
@synthesize nick;
@synthesize sex;
@synthesize location;
@synthesize created;
@synthesize last_visit;
@synthesize birthday;
@synthesize status;
@synthesize email;

@synthesize photo;
@synthesize creditDegree;
@synthesize goodCommentScore;
@synthesize totalCommentScore;
@synthesize isPassed;
@synthesize payAccount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [photo release];
    [creditDegree release];
    [goodCommentScore release];
    [totalCommentScore release];
    [isPassed release];
    [payAccount release];
    [frontLabel release];
    [frontImage release];
    [nick release];
    [sex release];
    [scrollView release];
    [location release];
    [created release];
    [last_visit release];
    [birthday release];
    [status release];
    [email release];
    [userInfoModel release];
    [searchBar release];
    [currentElement release];
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//用户跳转到淘宝授权
-(IBAction)searchAction:(id)sender
{
    self.webView.alpha=1.0f;
    
    NSURL *url=[NSURL URLWithString:LOGINURL];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    self.searchBar.text=LOGINURL;
    self.webView.scalesPageToFit=YES;
    self.webView.delegate=self;
    [self.webView loadRequest:theRequest];

    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.0f];
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    animation.type=@"rippleEffect";
    
    self.frontImage.image=nil;
    self.frontLabel.text=@"";
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self.view exchangeSubviewAtIndex:11 withSubviewAtIndex:10000];
    PLAYRIPPLESOUND;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"我的淘宝" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)]autorelease];
    self.userInfoModel=[[[UserInfoModel alloc] init] autorelease];
       
    UIView *userbgView=[self.view viewWithTag:101];
    userbgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"userInfo_bg.jpg"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.photo=nil;
    self.creditDegree=nil;
    self.goodCommentScore=nil;
    self.totalCommentScore=nil;
    self.isPassed=nil;
    self.payAccount=nil;
    self.webView=nil;
    self.searchBar=nil;
    self.scrollView=nil;
    self.nick=nil;
    self.sex=nil;
    self.created=nil;
    self.location=nil;
    self.last_visit=nil;
    self.birthday=nil;
    self.status=nil;
    self.email=nil;
    self.frontImage=nil;
    self.frontLabel=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.searchBar.text=[[self.webView.request URL] absoluteString];
    NSURL *newURL=[self.webView.request URL];
    NSString *urlString=[newURL absoluteString];
    NSRange range=[urlString rangeOfString:@"top_session"];
    if(range.location<1000)
    {
        self.webView.alpha=0.0f;
        NSString *url=[urlString substringFromIndex:range.location];
        url=[url substringFromIndex:12];
        
        NSRange subRange=[url rangeOfString:@"&"];
        NSString *sessionKey=[url substringToIndex:subRange.location];
        TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.sessionKey=sessionKey;
        
        NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
        [params setObject:@"taobao.user.get" forKey:@"method"];
        [params setObject:@"user_id,nick,sex,location,created,last_visit,birthday,status,email,avatar,buyer_credit,promoted_type,alipay_account" forKey:@"fields"];
        [params setObject:sessionKey forKey:@"session"];
        NSData *resultData=[Utility getResultData:params];

        NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
        [xmlParser setDelegate:self];
        [xmlParser parse];
        
        CATransition *animation=[CATransition animation];
        animation.delegate=self;
        animation.duration=1.0f;
        animation.timingFunction=UIViewAnimationCurveEaseInOut;
        animation.type=@"rippleEffect";
        

        [self.view.layer addAnimation:animation forKey:@"animation"];
        [self.view exchangeSubviewAtIndex:1000 withSubviewAtIndex:10000];
        
        CGSize newSize=self.view.frame.size;
        newSize.height+=220;
        self.scrollView.contentSize=newSize;
        PLAYRIPPLESOUND;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"user_id"])
    {
        self.userInfoModel.user_id=string;
    }
    if(![self.currentElement compare:@"nick"])
    {
        self.userInfoModel.nick=string;
        TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.nick=string;
    }
    if([self.currentElement isEqualToString:@"sex"])
    {
        self.userInfoModel.sex=string;
    }
    if(![self.currentElement compare:@"state"])
    {
        self.userInfoModel.location=[string stringByAppendingFormat:@"%@",self.userInfoModel.location];
    }
    if([self.currentElement isEqualToString:@"created"])
    {
        self.userInfoModel.created=string;
    }
    if([self.currentElement isEqualToString:@"last_visit"])
    {
        self.userInfoModel.last_visit=string;
    }
    if([self.currentElement isEqualToString:@"birthday"])
    {
        self.userInfoModel.birthday=string;
    }
    if([self.currentElement isEqualToString:@"status"])
    {
        if([self.currentElement isEqualToString:@"normal"])
        {
            self.userInfoModel.status=@"账号正常";
        }
        else if([self.currentElement isEqualToString:@"inactive"])
        {
            self.userInfoModel.status=@"账号未激活";
        }
        else if([self.currentElement isEqualToString:@"reeze"])
        {
            self.userInfoModel.status=@"账号被冻结";
        }
        else if([self.currentElement isEqualToString:@"supervise"])
        {
            self.userInfoModel.status=@"账号被监管";
        }
    }
    if([self.currentElement isEqualToString:@"city"])
    {
        self.userInfoModel.location=string;
    }
    if([self.currentElement isEqualToString:@"email"])
    {
        self.userInfoModel.email=string;
    }
    if([self.currentElement isEqualToString:@"avatar"])
    {
        self.userInfoModel.pic_url=string;
        self.userInfoModel.photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
    }
    if([self.currentElement isEqualToString:@"level"])
    {
        self.userInfoModel.creditDegree=string;
    }
    if([self.currentElement isEqualToString:@"total_num"])
    {
        self.userInfoModel.totalCommentScore=string;
    }
    if([self.currentElement isEqualToString:@"good_num"])
    {
        self.userInfoModel.goodCommentScore=string;
    }
    if([self.currentElement isEqualToString:@"promoted_type"])
    {
        if([self.currentElement isEqualToString:@"authentication"])
        {
            self.userInfoModel.isPassed=YES;
        }
        else
        {
            self.userInfoModel.isPassed=NO;
        }
    }
    if([self.currentElement isEqualToString:@"alipay_account"])
    {
        self.userInfoModel.payAccount=string;
    }
    
    self.nick.text=self.userInfoModel.nick;
    self.sex.text=self.userInfoModel.sex;
    self.location.text=self.userInfoModel.location;
    self.created.text=self.userInfoModel.created;
    self.last_visit.text=self.userInfoModel.last_visit;
    self.birthday.text=self.userInfoModel.birthday;
    self.status.text=self.userInfoModel.status;
    self.email.text=self.userInfoModel.email;
    self.photo.image=self.userInfoModel.photo;
    self.creditDegree.text=self.userInfoModel.creditDegree;
    self.totalCommentScore.text=self.userInfoModel.totalCommentScore;
    self.goodCommentScore.text=self.userInfoModel.goodCommentScore;
    if(self.userInfoModel.isPassed)
    {
        self.isPassed.text=@"实名认证";
    }
    else
    {
        self.isPassed.text=@"没有认证";
    }
    self.payAccount.text=self.userInfoModel.payAccount;
}

@end
