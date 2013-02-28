//
//  OtherView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-21.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "OtherView.h"


@implementation OtherView

@synthesize searchModel;
@synthesize overlayer;
@synthesize isloading;
@synthesize isItemUpdate;
@synthesize itemModel;
@synthesize shopModel;
@synthesize functionlist;
@synthesize tableView;
@synthesize tradeModel;
@synthesize datalist;
@synthesize currentElement;
@synthesize paylist;
@synthesize deliverlist;
@synthesize confirmlist;
@synthesize closelist;
@synthesize rootElement;
@synthesize commModel;
@synthesize commlist;
@synthesize googlist;
@synthesize neutrallist;
@synthesize badlist;

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
    [searchModel release];
    [overlayer release];
    [shopModel release];
    [itemModel release];
    [commModel release];
    [commlist release];
    [googlist release];
    [badlist release];
    [neutrallist release];
    [rootElement release];
    [paylist release];
    [deliverlist release];
    [confirmlist release];
    [closelist release];
    [tradeModel release];
    [currentElement release];
    [datalist release];
    [functionlist release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//得到用户SessionKey
-(BOOL)getSessionKey
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sessionKey==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登陆" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

//加载订单信息
-(void)loadTrades
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.datalist=[[[NSMutableArray alloc] init] autorelease];   
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.trades.bought.get" forKey:@"method"];
    [params setObject:@"tid,seller_nick,buyer_nick,created,status,price,post_fee,pay_time,pic_path,receiver_address,receiver_phone,orders.title" forKey:@"fields"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}

//发起我的收藏请求
//0宝贝收藏
//1店铺收藏
-(void)loadFavourites:(NSInteger)index
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.datalist=[[[NSMutableArray alloc]init]autorelease];
    if(appDelegate.sessionKey==nil)
    {
        return;
    }
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.favorite.search" forKey:@"method"];
    [params setObject:appDelegate.nick forKey:@"user_nick"];
    if(index==0)
    {
        [params setObject:@"ITEM" forKey:@"collect_type"];
    }
    else
    {
        [params setObject:@"SHOP" forKey:@"collect_type"];
    }
    [params setObject:@"1" forKey:@"page_no"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [pool release];
}

//视图加载时更新界面的收藏个数,然后接着请求店铺收藏的个数
-(void)updateFavouriteCount
{
    UITableViewCell *cell=(UITableViewCell *)[self.tableView viewWithTag:101];
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    NSMutableDictionary *params=[self.functionlist objectAtIndex:indexPath.row];
    [params removeObjectForKey:@"count"];
    if([self.itemModel.searchlist count]==0)
    {
        [params setObject:@"0" forKey:@"count"];
    }
    else
    {
        [params setObject:self.itemModel.total_result forKey:@"count"];
    }
    cell.detailTextLabel.text=self.itemModel.total_result;
    [self.tableView reloadData];
    isItemUpdate=NO;
    [self loadFavourites:1];
}

//更新店铺的收藏个数
-(void)udpateShopCount
{
    UITableViewCell *cell=(UITableViewCell *)[self.tableView viewWithTag:102];
    NSMutableDictionary *params=[self.functionlist objectAtIndex:3];
    [params removeObjectForKey:@"count"];
    if([self.shopModel.searchlist count]==0)
    {
        [params setObject:@"0" forKey:@"count"];
    }
    else
    {
        [params setObject:self.shopModel.total_result forKey:@"count"];
    }
    cell.detailTextLabel.text=self.shopModel.total_result;
    [self.tableView reloadData];
    isItemUpdate=YES;
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    isItemUpdate=YES;
    [NSThread detachNewThreadSelector:@selector(loadFavourites:) toTarget:self withObject:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    
    UIImage *img=[UIImage imageNamed:@"tradeinfo_bg.jpg"];
    UIImageView *imgView=[[UIImageView alloc] initWithImage:img];
    imgView.alpha=0.3f;
    self.tableView.backgroundView=imgView;
    
    self.functionlist=[[NSMutableArray alloc] init];
    NSMutableDictionary *functionOne=[[NSMutableDictionary alloc] init];
    [functionOne setObject:@"我的订单" forKey:@"name"];
    UIImage *imgOne=[UIImage imageNamed:@"tradelogo.png"];
    [functionOne setObject:imgOne forKey:@"image"];
    [self.functionlist addObject:functionOne];
    [functionOne release];
    
    NSMutableDictionary *functionThree=[[NSMutableDictionary alloc] init];
    [functionThree setObject:@"物流查询小工具" forKey:@"name"];
    UIImage *imgThree=[UIImage imageNamed:@"deliverlogo.png"];
    [functionThree setObject:imgThree forKey:@"image"];
    [self.functionlist addObject:functionThree];
    [functionThree release];
    
    
    NSMutableDictionary *functionFour=[[NSMutableDictionary alloc] init];
    [functionFour setObject:@"我的宝贝收藏" forKey:@"name"];
    UIImage *imgFour=[UIImage imageNamed:@"storelogo.png"];
    [functionFour setObject:imgFour forKey:@"image"];
    [functionFour setObject:@"0" forKey:@"count"];
    [self.functionlist addObject:functionFour];
    [functionFour release];
    
    
    NSMutableDictionary *functionFive=[[NSMutableDictionary alloc] init];
    [functionFive setObject:@"我的店铺收藏" forKey:@"name"];
    UIImage *imgFive=[UIImage imageNamed:@"carlogo.png"];
    [functionFive setObject:imgFive forKey:@"image"];
    [functionFive setObject:@"0" forKey:@"count"];
    [self.functionlist addObject:functionFive];
    [functionFive release];
    
    NSMutableDictionary *functionSix=[[NSMutableDictionary alloc] init];
    [functionSix setObject:@"评价管理" forKey:@"name"];
    UIImage *imgSix=[UIImage imageNamed:@"talkelogo.png"];
    [functionSix setObject:imgSix forKey:@"image"];
    [self.functionlist addObject:functionSix];
    [functionSix release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView=nil;
    self.overlayer=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma TableView 委托和数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.functionlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"BaseCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
    }
    NSMutableDictionary *params=[self.functionlist objectAtIndex:[indexPath row]];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text=[params objectForKey:@"name"];
    cell.imageView.image=[params objectForKey:@"image"];
    if(indexPath.row==2)
    {
        cell.tag=101;
        cell.detailTextLabel.text=[[self.functionlist objectAtIndex:indexPath.row] valueForKey:@"count"];
    }
    if(indexPath.row==3)
    {
        cell.tag=102;
        cell.detailTextLabel.text=[[self.functionlist objectAtIndex:indexPath.row] valueForKey:@"count"];
    }
    return cell;
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
        self.isloading=NO;
    }
}

-(void)startAnimation
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.overlayer.alpha=0.4f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overlayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self.view addSubview:self.overlayer];
    self.overlayer.alpha=1.0f;
    [UIView commitAnimations];
    [pool release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    if(indexPath.row==1)//物流查询工具(不是套博鳌的API)
    {
        DeliverSearchView *searchView=[[DeliverSearchView alloc] init];
        [self.navigationController pushViewController:searchView animated:YES];
        [searchView release];
    }
    else
    {
        if(![self getSessionKey])
        {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        if(indexPath.row==0)    //交易订单管理视图
        {
            [self loadTrades];
        }
        if(indexPath.row==2)    //我的宝贝收藏
        {
            FaviouriteView *favView=[[FaviouriteView alloc] initWithNibName:@"FaviouriteView" bundle:nil];
            favView.favModel.searchlist=self.itemModel.searchlist;
            favView.isItemFavourite=YES;
            if([self.itemModel.searchlist count]==0)
            {
                favView.maxCount=0;
            }
            else
            {
                favView.maxCount=[self.itemModel.total_result intValue];
            }
            [self.navigationController pushViewController:favView animated:YES];
        }
        if(indexPath.row==3)    //我的店铺收藏
        {
            FaviouriteView *favView=[[FaviouriteView alloc] initWithNibName:@"FaviouriteView" bundle:nil];
            favView.favModel.searchlist=self.shopModel.searchlist;
            favView.isItemFavourite=NO;
            [self.navigationController pushViewController:favView animated:YES];
        }
        if(indexPath.row==4)    //评价管理
        {
             CommentTypeView *commView=[[CommentTypeView alloc] initWithNibName:@"CommentTypeView" bundle:nil];
            [self.navigationController pushViewController:commView animated:YES];
        }
    }
}

#pragma XML解析，得到所有交易订单信息，并分类

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    if(isItemUpdate)
    {
        self.itemModel=[[[FavourModel alloc] init] autorelease];
        self.itemModel.searchlist=[[[NSMutableArray alloc]init]autorelease];
    }
    else
    {
        self.shopModel=[[[FavourModel alloc] init] autorelease];
        self.shopModel.searchlist=[[[NSMutableArray alloc]init] autorelease];
    }
    self.datalist=[[[NSMutableArray alloc] init] autorelease];
    self.paylist=[[[NSMutableArray alloc] init] autorelease];
    self.deliverlist=[[[NSMutableArray alloc]init] autorelease];
    self.confirmlist=[[[NSMutableArray alloc]init] autorelease];
    self.closelist=[[[NSMutableArray alloc]init] autorelease];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"trades"])
    {
        self.rootElement=elementName;
    }
    if(![self.currentElement compare:@"trade"])
    {
        self.tradeModel=[[TradeModel alloc] init];
        OrderModel *orderInfo=[[OrderModel alloc] init];
        [self.tradeModel setOrderModel:orderInfo];
        [orderInfo release];
    }
    
    if([self.currentElement isEqualToString:@"favorite_search_response"])
    {
        self.rootElement=elementName;
        if(isItemUpdate)//宝贝收藏
        {
            self.itemModel=[[[FavourModel alloc] init] autorelease];
            self.itemModel.searchlist=[[[NSMutableArray alloc] init] autorelease];
        }
        else
        {
            self.shopModel=[[[FavourModel alloc] init] autorelease];
            self.shopModel.searchlist=[[[NSMutableArray alloc] init] autorelease];
        }
    }
    if([self.currentElement isEqualToString:@"collect_item"])
    {
        self.searchModel=[[SearchModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //获取订单对象集合
    if([self.rootElement isEqualToString:@"trades"])
    {
        if(![self.currentElement compare:@"tid"])
        {
            self.tradeModel.tid=string;
        }
        if(![self.currentElement compare:@"buyer_nick"])
        {
            self.tradeModel.buyer_nick=string;
        }
        if(![self.currentElement compare:@"created"])
        {
            self.tradeModel.created=string;
        }
        
        if(![self.currentElement compare:@"status"])
        {
            self.tradeModel.status=string;
        }
        
        if(![self.currentElement compare:@"price"])
        {
            self.tradeModel.price=string;
        }
        
        if(![self.currentElement compare:@"post_fee"])
        {
            self.tradeModel.post_fee=string;
        }
        
        if(![self.currentElement compare:@"pay_time"])
        {
            self.tradeModel.pay_time=string;
        }
        
        if(![self.currentElement compare:@"pic_path"])
        {
            self.tradeModel.pic_path=string;
        }
        
        if(![self.currentElement compare:@"receiver_address"])
        {
            self.tradeModel.receiver_address=string;
        }
        
        if(![self.currentElement compare:@"receiver_phone"])
        {
            self.tradeModel.receiver_phone=string;
        }
        
        if(![self.currentElement compare:@"seller_nick"])
        {
            self.tradeModel.seller_nick=string;
        }
        
        if(![self.currentElement compare:@"title"])
        {
            self.tradeModel.orderModel.title=string;
        }
    }
    //获取我的收藏对象列表
    if([self.rootElement isEqualToString:@"favorite_search_response"])
    {
        if([self.currentElement isEqualToString:@"total_results"])
        {
            if(isItemUpdate)
            {
                self.itemModel.total_result=string;
            }
            else
            {
                self.shopModel.total_result=string;
            }
        }
        if([self.currentElement isEqualToString:@"item_numid"])
        {
            self.searchModel.item_id=string;
        }
        if([self.currentElement isEqualToString:@"item_owner_nick"])
        {
            self.searchModel.owner_nick=string;
        }
        if([self.currentElement isEqualToString:@"title"])
        {
            self.searchModel.item_title=string;
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentElement=elementName;
    if(![self.currentElement compare:@"trade"])
    {
        if([self.tradeModel.status isEqualToString:@"TRADE_FINISHED"])
        {
            self.tradeModel.status=@"交易关闭";
        }
        if([self.tradeModel.status isEqualToString:@"TRADE_CLOSED_BY_TAOBAO"])
        {
            self.tradeModel.status=@"交易自动关闭";
        }
        [self.datalist addObject:self.tradeModel];
        if([self.tradeModel.status isEqualToString:@"WAIT_BUYER_PAY"])
        {
            self.tradeModel.status=@"等待买家付款";
            [self.paylist addObject:self.tradeModel];
        }
        else if([tradeModel.status isEqualToString:@"WAIT_SELLER_SEND_GOODS"])
        {
            self.tradeModel.status=@"等待卖家发货";
            [self.deliverlist addObject:self.tradeModel];
        }
        else if([tradeModel.status isEqualToString:@"WAIT_BUYER_CONFIRM_GOODS"])
        {
            self.tradeModel.status=@"等待买家确认收货";
            [self.confirmlist addObject:self.tradeModel];
        }
        else if([tradeModel.status isEqualToString:@"TRADE_CLOSED"])
        {
            self.tradeModel.status=@"付款以后用户退款成功，交易自动关闭";
            [self.closelist addObject:self.tradeModel];
        }
        [self.tradeModel release];
    }
    if(![self.currentElement compare:@"trades"])
    {
        TradeTypeView *trdlistView=[[TradeTypeView alloc] initWithNibName:@"TradeTypeView" bundle:nil];
        trdlistView.tradelist=self.datalist;
        trdlistView.paylist=self.paylist;
        trdlistView.deliverlist=self.deliverlist;
        trdlistView.confirmlist=self.confirmlist;
        trdlistView.closelist=self.closelist;
        [self.navigationController pushViewController:trdlistView animated:YES];
    }
    
    
    if([self.currentElement isEqualToString:@"collect_item"])
    {
        if(isItemUpdate)
        {
            [self.itemModel.searchlist addObject:self.searchModel];
        }
        else
        {
            [self.shopModel.searchlist addObject:self.searchModel];
        }
        [self.searchModel release];
    }
    if([self.currentElement isEqualToString:@"favorite_search_response"])
    {
        //刷新主界面的收藏个数
        if(isItemUpdate)
        {
            [self performSelectorOnMainThread:@selector(updateFavouriteCount) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(udpateShopCount) withObject:nil waitUntilDone:YES];
        }
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

@end
