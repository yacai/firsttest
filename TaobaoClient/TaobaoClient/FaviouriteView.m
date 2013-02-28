//
//  FaviouriteView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "FaviouriteView.h"

@implementation FaviouriteView

@synthesize shopModel;
@synthesize searchModel;
@synthesize rootElement;
@synthesize maxCount;
@synthesize isloading;
@synthesize overlayer;
@synthesize isItemFavourite;
@synthesize tableView;
@synthesize favModel;
@synthesize proInfo;
@synthesize itemModel;
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
    [shopModel release];
    [searchModel release];
    [rootElement release];
    [overlayer release];
    [itemModel release];
    [proInfo release];
    [favModel release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//发起我的收藏请求
//0宝贝收藏
//1店铺收藏
-(void)loadFavourites:(NSInteger)index pageIndex:(NSInteger)pageIndex
{
    NSLog(@"%d",pageIndex);
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.favModel=[[[FavourModel alloc]init]autorelease];
    self.favModel.searchlist=[[[NSMutableArray alloc] init] autorelease];
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
    [params setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page_no"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [pool release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"我的宝贝收藏";
    
    if(isItemFavourite)//加载宝贝收藏
    {
        UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"itemfav_bg.jpg"]];
        bgImgView.alpha=0.3f;
        self.tableView.backgroundView=bgImgView;
        [bgImgView release];
    }
    else
    {
        UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopfav_bg.jpg"]];
        bgImgView.alpha=0.3f;
        self.tableView.backgroundView=bgImgView;
        [bgImgView release];
    }
    currentPage=1;
    if(maxCount%20>0)
    {
        maxPage=maxCount/20+1;
    }
    else
    {
        maxPage=maxCount/20;
    }
    
    if(isItemFavourite)//记载宝贝
    {
        [self loadFavourites:0 pageIndex:1];
    }
    else
    {
        [self loadFavourites:1 pageIndex:1];
    }
    
    DoubleTapSegmentedControl *segmentController=[[DoubleTapSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"上一页",@"下一页",nil]];
    segmentController.delegate=self;
    segmentController.segmentedControlStyle=UISegmentedControlStyleBar;
    segmentController.selectedSegmentIndex=0;
    segmentController.frame=CGRectMake(0, 0, 100, 30);
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:segmentController]autorelease];
    [segmentController release];
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

#pragma 表格数据源加载
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favModel.searchlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"FavouriteCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier]autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    SearchModel *searModel=[self.favModel.searchlist objectAtIndex:indexPath.row];
    cell.textLabel.text=searModel.item_title;
    cell.detailTextLabel.text=searModel.owner_nick;
    if(isItemFavourite)//宝贝收藏
    {
        cell.imageView.image=[UIImage imageNamed:@"fav_item.png"];
    }
    else
    {
         cell.imageView.image=[UIImage imageNamed:@"fav_shop.png"];
    }
    return cell;
}

#pragma 等待动画
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


//这里重利用产品详细信息视图，进行商品信息展示
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    if(isItemFavourite)//当前收藏的宝贝列表
    {
        SearchModel *selectedFav=[self.favModel.searchlist objectAtIndex:indexPath.row];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.item.get" forKey:@"method"];
        [params setObject:@"num_iid,title,pic_url,price,score,wap_detail_url,nick,type,volume,post_fee,express_fee,ems_fee,delist_time" forKey:@"fields"];
        [params setObject:selectedFav.item_id forKey:@"num_iid"];
        NSData *resultData=[Utility getResultData:params];
        [params release];
        NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
        [xmlParser setDelegate:self];
        [xmlParser parse];
        [xmlParser release];
    }
    else
    {
        SearchModel *shop=[self.favModel.searchlist objectAtIndex:indexPath.row];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:@"taobao.shop.get " forKey:@"method"];
        [params setObject:@"sid,title,shop_score,created" forKey:@"fields"];
        [params setObject:shop.owner_nick forKey:@"nick"];
        NSData *resultData=[Utility getResultData:params];
        [params release];
        
        NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
        [xmlParser setDelegate:self];
        [xmlParser parse];
        [xmlParser release];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

#pragma XML解析，获取单个商品的信息，并压入单个商品的信息

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    //加载单个商品
    if([elementName isEqualToString:@"item_get_response"])
    {
        self.rootElement=elementName;
    }
    if([elementName isEqualToString:@"item"])
    {
        self.itemModel=[[ItemProductModel alloc] init];
    }
    
    //加载一页收藏
    if([elementName isEqualToString:@"favorite_search_response"])
    {
        self.rootElement=elementName;
        self.favModel=[[[FavourModel alloc] init] autorelease];
        self.favModel.searchlist=[[[NSMutableArray alloc] init] autorelease];
    }
    if([elementName isEqualToString:@"collect_item"])
    {
        self.searchModel=[[SearchModel alloc] init];
    }
    
    if([elementName isEqualToString:@"shop_get_response"])
    {
        self.rootElement=elementName;
    }
    if([elementName isEqualToString:@"shop"])
    {
        self.shopModel=[[ShopModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{ 
#pragma 单个商品加载
    if([self.rootElement isEqualToString:@"item_get_response"])
    {
        if(![self.currentElement compare:@"num_iid"])
        {
            self.itemModel.num_iid=string;
        }
        if(![self.currentElement compare:@"title"])
        {
            self.itemModel.title=string;
        }
        if(![self.currentElement compare:@"pic_url"])
        {
            self.itemModel.pic_url=string;
            self.itemModel.photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:string]]];
        }
        if(![self.currentElement compare:@"price"])
        {
            self.itemModel.price=string;
        }
        if(![self.currentElement compare:@"score"])
        {
            self.itemModel.score=string;
        }
        if(![self.currentElement compare:@"nick"])
        {
            self.itemModel.seller_nick=string;
        }
        if(![self.currentElement compare:@"type"])
        {
            self.itemModel.item_type=string;
        }
        if(![self.currentElement compare:@"volume"])
        {
            self.itemModel.sell_count=string;
        }
        if(![self.currentElement compare:@"post_fee"])
        {
            self.itemModel.item_postfee=string;
        }
        if(![self.currentElement compare:@"express_fee"])
        {
            self.itemModel.item_express=string;
        }
        if(![self.currentElement compare:@"ems_fee"])
        {
            self.itemModel.item_EMS=string;
        }
        if(![self.currentElement compare:@"delist_time"])
        {
            self.itemModel.item_downShelf=string;
        }
        if(![self.currentElement compare:@"wap_detail_url"])
        {
            self.itemModel.wap_detail_url=string;
        }
    } 
    
#pragma 加载收藏列表
    if([self.rootElement isEqualToString:@"favorite_search_response"])
    {
        if([self.currentElement isEqualToString:@"total_result"])
        {
            self.favModel.total_result=string;
        }
        if([self.currentElement isEqualToString:@"item_owner_nick"])
        {
            self.searchModel.owner_nick=string;
        }
        if([self.currentElement isEqualToString:@"item_numid"])
        {
            self.searchModel.item_id=string;
        }
        if([self.currentElement isEqualToString:@"title"])
        {
            self.searchModel.item_title=string;
        }
    }
    
#pragma 获取单个店铺的信息
    if([self.rootElement isEqualToString:@"shop_get_response"])
    {
        if([self.currentElement isEqualToString:@"sid"])
        {
            self.shopModel.shopNum=string;
        }
        if([self.currentElement isEqualToString:@"title"])
        {
            self.shopModel.shoptitle=string;
        }
        if([self.currentElement isEqualToString:@"created"])
        {
            self.shopModel.shopCreate=string;
        }
        if([self.currentElement isEqualToString:@"item_score"])
        {
            self.shopModel.itemScore=string;
        }
        if([self.currentElement isEqualToString:@"service_score"])
        {
            self.shopModel.serviceScore=string;
        }
        if([self.currentElement isEqualToString:@"delivery_score"])
        {
            self.shopModel.sendScore=string;
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentElement=elementName;
    if([self.rootElement isEqualToString:@"item_get_response"])
    {
        if(![self.currentElement compare:@"item"])
        {
            ProductInfo *proInfoView=[[ProductInfo alloc] init];
            proInfoView.itemProductInfo=self.itemModel;
            proInfoView.isShowFavAdd=NO;
            [self.navigationController pushViewController:proInfoView animated:YES];
            [proInfoView release];
            [self.itemModel release];
        }
    }
    
    if([self.rootElement isEqualToString:@"favorite_search_response"])
    {
        if([self.currentElement isEqualToString:@"collect_item"])
        {
            [self.favModel.searchlist addObject:self.searchModel];
            [self.searchModel release];
        }
        if([self.currentElement isEqualToString:@"favorite_search_response"])
        {
            [self.tableView reloadData];
        }
    }
    
    if([self.rootElement isEqualToString:@"shop_get_response"])
    {
        if([self.currentElement isEqualToString:@"shop"])
        {
            ShopInfoView *shopView=[[ShopInfoView alloc] initWithNibName:@"ShopInfoView" bundle:nil];
            shopView.shopModel=self.shopModel;
            [self.navigationController pushViewController:shopView animated:YES];
        }
    }
}


//自定义双击Tab事件
-(void)performSegmentAction:(DoubleTapSegmentedControl *)sender
{
    if([self.favModel.searchlist count]>0)//获取淘宝的数据后加载
    {
        if([sender selectedSegmentIndex]==0)//上一页
        {
            if(currentPage>1)
            {
                PLAYEPAGESOUND;
                currentPage--;
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.tableView cache:YES];
                [UIView commitAnimations];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!已经是第一页了！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        else
        {
            if(currentPage<maxPage)
            {
                PLAYEPAGESOUND;
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.tableView cache:YES];
                currentPage++;
                [UIView commitAnimations];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!已经是最后一页了！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        if(isItemFavourite)
        {
            [self loadFavourites:0 pageIndex:currentPage];
        }
        else
        {
            [self loadFavourites:1 pageIndex:currentPage];
        }
    }
}

@end
