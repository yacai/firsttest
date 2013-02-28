//
//  ProductInfo.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "ProductInfo.h"


@implementation ProductInfo

@synthesize overlayer;
@synthesize isloading;
@synthesize currentElement;
@synthesize isShowFavAdd;
@synthesize favAdd;
@synthesize item_title;
@synthesize price;
@synthesize score;
@synthesize photo;
@synthesize itemProductInfo;
@synthesize webView;
@synthesize scrollView;
@synthesize item_EMS;
@synthesize item_type;
@synthesize item_express;
@synthesize item_postfee;
@synthesize item_downShelf;
@synthesize sell_count;
@synthesize seller_nick;

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
    [overlayer release];
    [currentElement release];
    [favAdd release];
    [item_downShelf release];
    [item_EMS release];
    [item_type release];
    [item_express release];
    [item_postfee release];
    [sell_count release];
    [seller_nick release];
    [scrollView release];
    [webView release];
    [item_title release];
    [price release];
    [score release];
    [photo release];
    [itemProductInfo release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//返回商品信息视图
-(void)backProductInfo
{
    PLAYRIPPLESOUND;
    self.scrollView.alpha=1.0f;
    self.webView.alpha=0.0f;
    self.navigationItem.rightBarButtonItem=nil;
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=1.0f;
    animation.type=@"rippleEffect";
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self.view exchangeSubviewAtIndex:100 withSubviewAtIndex:200];
}

//前去支付宝付款,URL代码没有问题，有的可以使用有的地址有问题
-(IBAction)payAction:(id)sender
{
    PLAYRIPPLESOUND;
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backProductInfo)]autorelease];
    self.webView.alpha=1.0f;
    NSURL *url=[NSURL URLWithString:self.itemProductInfo.wap_detail_url];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:theRequest];
    
    self.scrollView.alpha=0.0f;
    CATransition *animation=[CATransition animation];
    animation.delegate=self;
    animation.duration=1.0f;
    animation.type=@"rippleEffect";
    animation.timingFunction=UIViewAnimationCurveEaseInOut;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self.view exchangeSubviewAtIndex:100 withSubviewAtIndex:200];
}


-(void)dismissLayer
{
    [self.overlayer removeFromSuperview];
}

-(void)stopAnimation
{
    self.overlayer.alpha=1.0f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overlayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [UIView beginAnimations:nil context:context];
    self.overlayer.alpha=0.0f;
    [UIView commitAnimations];
    [self performSelector:@selector(dismissLayer) withObject:nil afterDelay:0.4f];
}

-(void)isFinshed:(NSTimer *)timer
{
    count++;
    if(count>=10)
    {
        [self stopAnimation];
        [timer invalidate];
        self.isloading=NO;
        return;
    }
    if(!self.isloading&&count>1)
    {
        [self stopAnimation];
        [timer invalidate];
    }
}

//开始等待动画
-(void)startAnimation
{
    self.overlayer.alpha=0.0f;
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.overlayer.alpha=0.4f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overlayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [UIView beginAnimations:nil context:context];
    [self.view addSubview:self.overlayer];
    self.overlayer.alpha=1.0f;
    [UIView commitAnimations];
    [pool release];
}

//添加到我的收藏夹
-(IBAction)addFavourite:(id)sender
{
    PLAYBUTTONSOUND;
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegate.sessionKey isEqualToString:@""]||appDelegate.sessionKey==nil)
    {  
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有登陆" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"taobao.favorite.add" forKey:@"method"];
    [params setObject:@"ITEM" forKey:@"collect_type"];
    [params setObject:@"false" forKey:@"shared"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    [params setObject:self.itemProductInfo.num_iid forKey:@"item_numid"];
    NSData *resultData=[Utility getResultData:params];
    [params release];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGSize newSize=self.view.frame.size;
    newSize.height+=560;
    self.scrollView.contentSize=newSize;

    if(self.itemProductInfo!=nil)
    {
        self.navigationItem.title=self.itemProductInfo.title;
        self.item_title.text=self.itemProductInfo.title;
        self.price.text=self.itemProductInfo.price;
        self.score.text=self.itemProductInfo.score;
        self.photo.image=self.itemProductInfo.photo;
        self.item_downShelf.text=self.itemProductInfo.item_downShelf;
        self.item_EMS.text=self.itemProductInfo.item_EMS;
        self.item_express.text=self.itemProductInfo.item_express;
        self.item_postfee.text=self.itemProductInfo.item_postfee;
        if([self.itemProductInfo.item_type isEqualToString:@"fixed"])
        {
            self.item_type.text=@"一口价";
        }
        else
        {
            self.item_type.text=@"拍卖";
        }
        self.sell_count.text=self.itemProductInfo.sell_count;
        self.seller_nick.text=self.itemProductInfo
        .seller_nick;
    }
    if(!isShowFavAdd)//不显示“添加到收藏夹”按钮，这个是收藏夹里查看商品详细信息
    {
        [self.favAdd removeFromSuperview];
        self.favAdd=nil;
        [self.favAdd release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.favAdd=nil;
    self.overlayer=nil;
    self.item_title=nil;
    self.price=nil;
    self.score=nil;
    self.photo=nil;
    self.webView=nil;
    self.scrollView=nil;
    self.item_downShelf=nil;
    self.item_EMS=nil;
    self.item_express=nil;
    self.item_postfee=nil;
    self.item_type=nil;
    self.sell_count=nil;
    self.seller_nick=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;   
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"success"])
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加收藏夹成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    if([self.currentElement isEqualToString:@"sub_msg"])
    {
            
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
@end
