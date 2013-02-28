//
//  ProductSearch.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "ProductSearch.h"


@implementation ProductSearch

@synthesize searchBar;
@synthesize itemProlist;
@synthesize currentElement;
@synthesize itemProModel;
@synthesize tableView;
@synthesize overlayer;
@synthesize isloading;
@synthesize isSearch;
@synthesize detailView;
@synthesize goodFirst;
@synthesize taobaoItem;
@synthesize wangwangOnline;
@synthesize securityItem;
@synthesize noFake;
@synthesize noPostfee;
@synthesize defaillist;

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
    [detailView release];
    [overlayer release];
    [currentElement release];
    [itemProModel release];
    [tableView release];
    [itemProlist release];
    [searchBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

//按照关键字直接搜索商品
-(void)searchProducts:(id)sender
{
    PLAYBUTTONSOUND;
    [self.searchBar resignFirstResponder];
    if(self.searchBar.text==nil||[self.searchBar.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"搜索的商品名称不能为空！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    self.isSearch=YES;
    self.isloading=YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"taobao.items.search" forKey:@"method"];
    [params setObject:@"num_iid,title,pic_url,price" forKey:@"fields"];
    for(NSString *value in self.defaillist)
    {
        if([value isEqualToString:@"promoted_service"])
        {
            [params setObject:@"2" forKey:value];
        }
        else
        {
            [params setObject:@"true" forKey:value];
        }
    }
    [params setObject:self.searchBar.text forKey:@"q"];
    NSData *resultData=[Utility getResultData:params];
    [params release];
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

-(void)flipAnimation:(NSInteger)type
{
    UIView *lastView=[self.view viewWithTag:100];
    UIView *frontView=[self.view viewWithTag:101];
    UIView *backView=[self.view viewWithTag:102];
    
    NSUInteger frontIndex=[[lastView subviews]indexOfObject:frontView];
    NSUInteger backIndex=[[lastView subviews] indexOfObject:backView];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    if(type==0)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    }
    [lastView exchangeSubviewAtIndex:frontIndex
                   withSubviewAtIndex:backIndex];
    [UIView commitAnimations];

}

//返回翻转前的视图
-(void)backFrontView
{
    PLAYBUTTONSOUND;
    [self flipAnimation:1];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"搜素商品" style:UIBarButtonItemStylePlain target:self action:@selector(searchProducts:)] autorelease];
    
}

//详细搜索
-(void)detailSearch:(id)sender
{
    PLAYBUTTONSOUND;
    [self flipAnimation:0];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(backFrontView)] autorelease];
}

//显示搜索店铺的页面
-(void)shopSearchAction:(id)sender
{
    PLAYBUTTONSOUND;
    shopSearchView *shopView=[[shopSearchView alloc] initWithNibName:@"shopSearchView" bundle:nil];
    UINavigationController *shopNavView=[[UINavigationController alloc] initWithRootViewController:shopView];
    [self presentModalViewController:shopNavView animated:YES];
    [shopView release];
}

-(IBAction)codAction:(id)sender
{
    NSString *condition=[NSString stringWithFormat:@"%@",@"is_cod"];
    if([sender isOn])
    {
        [self.defaillist addObject:condition];
    }
    else
    {
        if([self.defaillist indexOfObject:condition]>0)
        {
            [self.defaillist removeObject:condition];
        }
    }
}

-(IBAction)mallAction:(id)sender
{
    NSString *condition=[NSString stringWithFormat:@"%@",@"is_mall"];
    if([sender isOn])
    {
        [self.defaillist addObject:condition];
    }
    else
    {
        if([self.defaillist indexOfObject:condition]>0)
        {
            [self.defaillist removeObject:condition];
        }
    }
}

-(IBAction)wangwangAction:(id)sender
{
    if([sender isOn])
    {
        [self.defaillist addObject:@"ww_status"];
    }
    else
    {
        if([self.defaillist indexOfObject:@"ww_status"]>0)
        {
            [self.defaillist removeObject:@"ww_status"];
        }
    }
}

-(IBAction)securityActoin:(id)sender
{
    if([sender isOn])
    {
        [self.defaillist addObject:@"genuine_security"];
    }
    else
    {
        if([self.defaillist indexOfObject:@"genuine_security"]>0)
        {
            [self.defaillist removeObject:@"genuine_security"];
        }
    }
}

-(IBAction)promotedAction:(id)sender
{
    if([sender isOn])
    {
        [self.defaillist addObject:@"promoted_service"];
    }
    else
    {
        if([self.defaillist indexOfObject:@"promoted_service"]>0)
        {
            [self.defaillist removeObject:@"promoted_service"];
        }
    }
}

-(IBAction)postfeeAction:(id)sender
{
    if([sender isOn])
    {
        [self.defaillist addObject:@"post_free"];
    }
    else
    {
        if([self.defaillist indexOfObject:@"post_free"]>0)
        {
            [self.defaillist removeObject:@"post_free"];
        }
    }
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    if(self.overlayer.superview!=nil)
    {
        [self.overlayer removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemProlist=[[NSMutableArray alloc] init];
    self.defaillist=[[[NSMutableArray alloc] init] autorelease];
    [self.defaillist addObject:@"fist"];
    self.isloading=NO;
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bg.jpg"]];
    img.alpha=0.3;
    self.tableView.backgroundView=img;
    [img release];

    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"搜素商品" style:UIBarButtonItemStylePlain target:self action:@selector(searchProducts:)] autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"店铺搜索" style:UIBarButtonItemStylePlain target:self action:@selector(shopSearchAction:)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.searchBar=nil;
    self.tableView=nil;
    self.overlayer=nil;
    self.detailView=nil;
    self.goodFirst=nil;
    self.taobaoItem=nil;
    self.securityItem=nil;
    self.noFake=nil;
    self.noPostfee=nil;
    self.wangwangOnline=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{  
    if(self.isSearch)
    {
        [self.itemProlist removeAllObjects];
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"item"])
    {
        if(self.isSearch)
        {
            self.itemProModel=[[ItemProductModel alloc] init];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"item"])
    {
        if(self.isSearch)
        {
            [self.itemProlist addObject:self.itemProModel];
            [self.itemProModel release]; 
        }
        else
        {
            ProductInfo *proInfoView=[[ProductInfo alloc] init];
            proInfoView.itemProductInfo=self.itemProModel;
            proInfoView.isShowFavAdd=YES;
            [self.navigationController pushViewController:proInfoView animated:YES];
            [proInfoView release];
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(![self.currentElement compare:@"num_iid"])
    {
        self.itemProModel.num_iid=string;
    }
    if(![self.currentElement compare:@"title"])
    {
        self.itemProModel.title=string;
    }
    if(![self.currentElement compare:@"pic_url"])
    {
        self.itemProModel.pic_url=string;
    }
    if(![self.currentElement compare:@"price"])
    {
        self.itemProModel.price=string;
    }
    if(![self.currentElement compare:@"wap_detail_url"])
    {
        self.itemProModel.wap_detail_url=string;
    }
    if(![self.currentElement compare:@"nick"])
    {
        self.itemProModel.seller_nick=string;
    }
    if(![self.currentElement compare:@"type"])
    {
        self.itemProModel.item_type=string;
    }
    if(![self.currentElement compare:@"volume"])
    {
        self.itemProModel.sell_count=string;
    }
    if(![self.currentElement compare:@"post_fee"])
    {
        self.itemProModel.item_postfee=string;
    }
    if(![self.currentElement compare:@"express_fee"])
    {
        self.itemProModel.item_express=string;
    }
    if(![self.currentElement compare:@"ems_fee"])
    {
        self.itemProModel.item_EMS=string;
    }
    if(![self.currentElement compare:@"delist_time"])
    {
        self.itemProModel.item_downShelf=string;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.navigationItem.title=[@"商品搜索" stringByAppendingFormat:@"(%d)",[self.itemProlist count]];
    if(self.isSearch)
    {
        [self.tableView reloadData];
    }
    self.isloading=NO;
    self.isSearch=YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemProlist count];
}

-(void)downloadImageforCell:(NSIndexPath *)indexPath
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    ItemProductModel *itemPro=[self.itemProlist objectAtIndex:indexPath.row];
    if(itemPro.photo==nil)
    {
        if(itemPro.pic_url==nil)
        {
            UIImage *img=[UIImage imageNamed:@"no_pic.jpeg"];
            itemPro.photo=img;
        }
        else 
        {
            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemPro.pic_url]]];
            itemPro.photo=img;
        }
    }
    [self performSelectorOnMainThread:@selector(updateCellImage:) withObject:indexPath waitUntilDone:YES];
    [pool release];
}

-(void)updateCellImage:(NSIndexPath *)indexPath
{
    ItemProductModel *itemProInfo=[self.itemProlist objectAtIndex:indexPath.row];
    ProductCell *cell=(ProductCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[cell.proImage viewWithTag:102];
    [actView stopAnimating];
    [actView removeFromSuperview];
    cell.proImage.image=itemProInfo.photo;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ProductCell";
    ProductCell *cell=(ProductCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ProductCell class]])
            {
                cell=(ProductCell *)oneObject;
            }
        }
    }

    ItemProductModel *itemProInfo=[self.itemProlist objectAtIndex:indexPath.row];
    cell.title.text=itemProInfo.title;
    cell.price.text=itemProInfo.price;
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    UIActivityIndicatorView *actView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    actView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [actView startAnimating];
    actView.center=cell.proImage.center;
    actView.tag=102;
    [cell.proImage addSubview:actView];
    [actView release];
    
    [NSThread detachNewThreadSelector:@selector(downloadImageforCell:) toTarget:self withObject:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [self.searchBar resignFirstResponder];
    self.isSearch=NO;
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    ItemProductModel *itemProInfo=[self.itemProlist objectAtIndex:indexPath.row];
    self.itemProModel=itemProInfo;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:@"taobao.item.get" forKey:@"method"];
    [params setObject:@"num_iid,title,pic_url,price,score,wap_detail_url,nick,type,volume,post_fee,express_fee,ems_fee,delist_time" forKey:@"fields"];
    [params setObject:itemProInfo.num_iid forKey:@"num_iid"];
    NSData *resultData=[Utility getResultData:params];
    [params release];
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
@end
