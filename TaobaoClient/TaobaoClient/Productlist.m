//
//  Productlist.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "Productlist.h"


@implementation Productlist
@synthesize itemCat;
@synthesize itemProlist;
@synthesize tableView;
@synthesize overLayer;
@synthesize currentElement;
@synthesize itemProInfo;

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
    [itemProInfo release];
    [currentElement release];
    [overLayer release];
    [tableView release];
    [itemProlist release];
    [itemCat release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    if(self.overLayer.superview!=nil)
    {
        [self.overLayer removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.itemCat!=nil)
    {
        self.title=self.itemCat.name;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView=nil;
    self.overLayer=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemProlist count];
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
    ItemProductModel *itemProModel=[self.itemProlist objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.title.text=itemProModel.title;
    cell.price.text=itemProModel.price;
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

-(void)downloadImageforCell:(NSIndexPath *)indexPath
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    ItemProductModel *itemProModel=[self.itemProlist objectAtIndex:indexPath.row];
    if(itemProModel.photo==nil)
    {
        if(itemProModel.pic_url==nil)
        {
            UIImage *img=[UIImage imageNamed:@"no_pic.jpeg"];
            itemProModel.photo=img;
        }
        else
        {
            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemProModel.pic_url]]];
            itemProModel.photo=img;
        }
    }
    [self performSelectorOnMainThread:@selector(updateCellImage:) withObject:indexPath waitUntilDone:YES];
    [pool release];
}

-(void)updateCellImage:(NSIndexPath *)indexPath
{
    ItemProductModel *itemProModel=[self.itemProlist objectAtIndex:indexPath.row];
    ProductCell *cell=(ProductCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[cell.proImage viewWithTag:102];
    [actView stopAnimating];
    [actView removeFromSuperview];
    cell.proImage.image=itemProModel.photo;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(void)startAnimation
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.overLayer.alpha=0.4f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overLayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [UIView beginAnimations:nil context:context];
    [self.view addSubview:self.overLayer];
    self.overLayer.alpha=1.0f;
    [UIView commitAnimations];
    [pool release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    

    self.itemProInfo=[self.itemProlist objectAtIndex:indexPath.row];
    
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentElement=elementName;
    if(![self.currentElement compare:@"item"])
    {
        ProductInfo *proInfoView=[[ProductInfo alloc] init];
        proInfoView.itemProductInfo=itemProInfo;
        proInfoView.isShowFavAdd=YES;
        [self.navigationController pushViewController:proInfoView animated:YES];
        [proInfoView release];
    }
}

//nick,type,volume,post_fee,express_fee,ems_fee,delist_time
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(![self.currentElement compare:@"nick"])
    {
        self.itemProInfo.seller_nick=string;
    }
    if(![self.currentElement compare:@"type"])
    {
        self.itemProInfo.item_type=string;
    }
    if(![self.currentElement compare:@"volume"])
    {
        self.itemProInfo.sell_count=string;
    }
    if(![self.currentElement compare:@"post_fee"])
    {
        self.itemProInfo.item_postfee=string;
    }
    if(![self.currentElement compare:@"express_fee"])
    {
        self.itemProInfo.item_express=string;
    }
    if(![self.currentElement compare:@"ems_fee"])
    {
        self.itemProInfo.item_EMS=string;
    }
    if(![self.currentElement compare:@"delist_time"])
    {
        self.itemProInfo.item_downShelf=string;
    }
    if(![self.currentElement compare:@"wap_detail_url"])
    {
        self.itemProInfo.wap_detail_url=string;
    }
}
@end
