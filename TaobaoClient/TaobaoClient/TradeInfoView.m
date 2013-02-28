//
//  TradeInfo.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TradeInfoView.h"


@implementation TradeInfoView

@synthesize tradeModel;
@synthesize delTraceModel;
@synthesize scrollView;
@synthesize item_title;
@synthesize seller_nick;
@synthesize buyer_nick;
@synthesize created;
@synthesize status;
@synthesize pay_time;
@synthesize price;
@synthesize post_fee;
@synthesize receiver_phone;
@synthesize receiver_address;
@synthesize pic;
@synthesize currentElement;
@synthesize delModel;

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
    [currentElement release];
    [delTraceModel release];
    [delModel release];
    [title release];
    [seller_nick release];
    [buyer_nick release];
    [created release];
    [status release];
    [pay_time release];
    [price release];
    [post_fee release];
    [receiver_phone release];
    [receiver_address release];
    [pic release];
    [scrollView release];
    [tradeModel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//查看该淘宝订单的物流流转信息
-(void)showDeliverInfo
{
    self.navigationItem.rightBarButtonItem=nil;
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.logistics.trace.search" forKey:@"method"];
    //注：这里是淘宝交易号不是物流号
    [params setObject:self.tradeModel.tid forKey:@"tid"];
    [params setObject:self.tradeModel.seller_nick forKey:@"seller_nick"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"订单详情";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"查看物流状态" style:UIBarButtonItemStylePlain target:self action:@selector(showDeliverInfo)]autorelease];
    
    CGSize newSize=self.view.frame.size;
    newSize.height+=420;
    self.scrollView.contentSize=newSize;
    
    self.pic.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.tradeModel.pic_path]]];
    self.item_title.text=self.tradeModel.orderModel.title;
    self.seller_nick.text=self.tradeModel.seller_nick;
    self.buyer_nick.text=self.tradeModel.buyer_nick;
    self.created.text=self.tradeModel.created;
    self.status.text=self.tradeModel.status;
    self.pay_time.text=self.tradeModel.pay_time;
    self.price.text=self.tradeModel.price;
    self.post_fee.text=self.tradeModel.post_fee;
    self.receiver_phone.text=self.tradeModel.receiver_phone;
    self.receiver_address.text=self.tradeModel.receiver_address;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView=nil;
    self.item_title=nil;
    self.seller_nick=nil;
    self.buyer_nick=nil;
    self.created=nil;
    self.status=nil;
    self.pay_time=nil;
    self.price=nil;
    self.post_fee=nil;
    self.receiver_phone=nil;
    self.receiver_address=nil;
    self.pic=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma XML解析，得到订单的物流信息

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"logistics_trace_search_response"])
    {
        self.delModel=[[DeliverModel alloc] init];
        self.delModel.delTraceModel=[[[NSMutableArray alloc] init] autorelease];
    }
    if([elementName isEqualToString:@"transit_step_info"])
    {
        self.delTraceModel=[[DeliverTraceModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"out_sid"])
    {
        self.delModel.out_sid=string;
    }
    if([self.currentElement isEqualToString:@"company_name"])
    {
        self.delModel.company_name=string;
    }
    if([self.currentElement isEqualToString:@"status"])
    {
        self.delModel.status=string;
    }
    if([self.currentElement isEqualToString:@"status_time"])
    {
        self.delTraceModel.status_time=string;
    }
    if([self.currentElement isEqualToString:@"status_desc"])
    {
        self.delTraceModel.status_desc=string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"transit_step_info"])
    {
        [self.delModel.delTraceModel addObject:self.delTraceModel];
        [self.delTraceModel release];
    }
    if([elementName isEqualToString:@"logistics_trace_search_response"])
    {
        NSString *traceString=@"";
        for(DeliverTraceModel *delTrace in self.delModel.delTraceModel)
        {
            traceString=[traceString stringByAppendingFormat:@"%@%@\n",delTrace.status_time,delTrace.status_desc];
        }
        NSString *resultString=[NSString stringWithFormat:
                          @"运单号:%d\n物流公司名称:%@\n订单状态:%@\n%@" 
                          ,self.delModel.out_sid
                          ,self.delModel.company_name
                          ,self.delModel.status
                          ,traceString];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:resultString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.delModel release];
    }
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"查看物流状态" style:UIBarButtonItemStylePlain target:self action:@selector(showDeliverInfo)]autorelease];
}
@end
