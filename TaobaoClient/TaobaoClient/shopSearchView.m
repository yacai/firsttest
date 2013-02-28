//
//  shopSearchView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-22.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "shopSearchView.h"


@implementation shopSearchView

@synthesize msg;
@synthesize addFav;
@synthesize shopNum;
@synthesize shoptitle;
@synthesize shopScore;
@synthesize shopCreate;
@synthesize itemScore;
@synthesize serviceScore;
@synthesize sendScore;
@synthesize scrollView;
@synthesize searchBar;
@synthesize overlayer;
@synthesize isLoading;
@synthesize shopInfo;
@synthesize currentElement;

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
    [msg release];
    [addFav release];
    [shopInfo release];
    [currentElement release];
    [overlayer release];
    [searchBar release];
    [scrollView release];
    [shopNum release];
    [shopCreate release];
    [shoptitle release];
    [shopScore release];
    [itemScore release];
    [serviceScore release];
    [sendScore release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)cancelAction:(id)sender
{
    PLAYBUTTONSOUND;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dismissLayer
{
    [self.overlayer removeFromSuperview];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"搜索店铺" style:UIBarButtonItemStylePlain target:self action:@selector(searchShop:)] autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)] autorelease];
}

-(void)stopWaiting
{
    self.overlayer.alpha=1.0f;
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.overlayer.alpha=0.0f;
    [UIView commitAnimations];
    [self performSelector:@selector(dismissLayer) withObject:nil afterDelay:0.4f];
}

-(void)isFinished:(NSTimer *)timer
{
    count++;
    if(count>=10)
    {
        self.isLoading=NO;
        [timer invalidate];
        [self stopWaiting];
    }
    if(count>1&&!self.isLoading)//不要忘记返回数据后把标示isLoading设置为NO
    {
        [timer invalidate];
        [self stopWaiting];
    }
}

-(void)sartWaiting
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    UIActivityIndicatorView *actView=(UIActivityIndicatorView  *)[self.overlayer viewWithTag:222];
    [actView startAnimating];
    self.overlayer.alpha=0.0f;
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self.view addSubview:self.overlayer];
    self.overlayer.alpha=1.0;
    [UIView commitAnimations];
    [pool release];
}

//搜索店铺信息
-(void)searchShop:(id)sender
{
    PLAYBUTTONSOUND;
    [self.searchBar resignFirstResponder];
    if([self.searchBar.text isEqualToString:@""]||self.searchBar.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入需要查询的店铺名称" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    count=0;
    self.isLoading=YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinished:) userInfo:nil repeats:YES];
    
    [NSThread detachNewThreadSelector:@selector(sartWaiting) toTarget:self withObject:nil];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"taobao.shop.get " forKey:@"method"];
    [params setObject:@"sid,title,shop_score,created" forKey:@"fields"];
    [params setObject:self.searchBar.text forKey:@"nick"];
    NSData *resultData=[Utility getResultData:params];
    [params release];
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

//把搜索到的店铺添加到我的收藏夹
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
    
    if([self.shopNum.text isEqualToString:@""]||self.shopNum.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有搜索到任何店铺信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinished:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(sartWaiting) toTarget:self withObject:nil];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"taobao.favorite.add" forKey:@"method"];
    [params setObject:@"SHOP" forKey:@"collect_type"];
    [params setObject:@"false" forKey:@"shared"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    [params setObject:self.shopNum.text forKey:@"item_numid"];
    NSData *resultData=[Utility getResultData:params];
    [params release];
    NSLog(@"%@",[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]);
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"搜索店铺" style:UIBarButtonItemStylePlain target:self action:@selector(searchShop:)] autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)] autorelease];
    
    //设置底层的ScrollView的区域大小
    CGSize newSize=self.view.frame.size;
    newSize.height=420;
    self.scrollView.contentSize=newSize;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.addFav=nil;
    self.overlayer=nil;
    self.searchBar=nil;
    self.shopNum=nil;
    self.shoptitle=nil;
    self.shopCreate=nil;
    self.shopScore=nil;
    self.itemScore=nil;
    self.serviceScore=nil;
    self.sendScore=nil;
    self.scrollView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"shop"])
    {
        self.shopInfo=[[ShopModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"sid"])
    {
        self.shopInfo.shopNum=string;
    }
    if([self.currentElement isEqualToString:@"title"])
    {
        self.shopInfo.shoptitle=string;
    }
    if([self.currentElement isEqualToString:@"created"])
    {
        self.shopInfo.shopCreate=string;
    }
    if([self.currentElement isEqualToString:@"item_score"])
    {
        self.shopInfo.itemScore=string;
    }
    if([self.currentElement isEqualToString:@"service_score"])
    {
        self.shopInfo.serviceScore=string;
    }
    if([self.currentElement isEqualToString:@"delivery_score"])
    {
        self.shopInfo.sendScore=string;
    }
    if([self.currentElement isEqualToString:@"sub_msg"])
    {
        self.msg=string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"shop"])
    {
        self.shopNum.text=self.shopInfo.shopNum;
        self.shoptitle.text=self.shopInfo.shoptitle;
        self.shopCreate.text=self.shopInfo.shopCreate;
        self.itemScore.text=self.shopInfo.itemScore;
        self.serviceScore.text=self.shopInfo.serviceScore;
        self.sendScore.text=self.shopInfo.sendScore;
        [self.shopInfo release];
    }
    if([elementName isEqualToString:@"success"])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加收藏夹成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    if([elementName isEqualToString:@"sub_msg"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.isLoading=NO;
}
@end
