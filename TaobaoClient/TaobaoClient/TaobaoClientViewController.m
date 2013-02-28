//
//  TaobaoClientViewController.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TaobaoClientViewController.h"

@implementation TaobaoClientViewController

@synthesize itemCatlist;
@synthesize itemProlist;
@synthesize itemPro;
@synthesize itemCat;
@synthesize currentElement;
@synthesize isLoadProlist;
@synthesize tableView;
@synthesize overLayer;
@synthesize currentCatlist;

- (void)dealloc
{
    [currentCatlist release];
    [itemProlist release];
    [itemPro release];
    [currentElement release];
    [itemCat release];
    [itemCatlist release];
    [tableView release];
    [overLayer release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//获取淘宝所有的种类
-(void)getItemCats
{
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"cid,name" forKey:@"fields"];
    [params setObject:@"0" forKey:@"parent_cid"];
    [params setObject:@"taobao.itemcats.get" forKey:@"method"];

    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

//加载制定页数的数据,每页20条
-(void)reloadTableInPage:(NSInteger)index
{
    self.currentCatlist=[[[NSMutableArray alloc] init] autorelease];
    if([self.itemCatlist count]<20)
    {
        for(int i=0;i<(index-1)*20+[self.itemCatlist count];i++)
        {
            ItemCategoryModel *selectCat=[self.itemCatlist objectAtIndex:i];
            [self.currentCatlist addObject:selectCat];
        }

    }
    else
    {
        for(int i=(index-1)*20;i<(index-1)*20+20;i++)
        {
            ItemCategoryModel *selectCat=[self.itemCatlist objectAtIndex:i];
            [self.currentCatlist addObject:selectCat];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

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

    currentPage=1;//设置默认显示第一页
    
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cat_bg.jpg"]];
    img.alpha=0.3;
    self.tableView.backgroundView=img;
    [img release];
    self.isLoadProlist=NO;
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    
    self.itemProlist=[[[NSMutableArray alloc] init] autorelease];
    self.itemCatlist=[[[NSMutableArray alloc] init] autorelease];
    
    DoubleTapSegmentedControl *segmentController=[[DoubleTapSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"上一页",@"下一页",nil]];
    segmentController.delegate=self;
    segmentController.segmentedControlStyle=UISegmentedControlStyleBar;
    segmentController.selectedSegmentIndex=0;
    segmentController.frame=CGRectMake(0, 0, 100, 30);
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:segmentController]autorelease];
    [segmentController release];
    [self getItemCats];
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

#pragma 解析XML，获取淘宝商品类别
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"item_cat"])
    {
         self.itemCat=[[ItemCategoryModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //商品类别
    if(![self.currentElement compare:@"cid"])
    {
        self.itemCat.cid=string;
    }
    if(![self.currentElement compare:@"name"])
    {
        self.itemCat.name=string;
    }
    
    if(self.isLoadProlist)
    {
        //类别下的商品
        if(![self.currentElement compare:@"num_iid"])
        {
            self.itemPro=[[ItemProductModel alloc] init];
            self.itemPro.num_iid=string;
        }
        if(![self.currentElement compare:@"title"])
        {
            self.itemPro.title=string;
        }
        if(![self.currentElement compare:@"pic_url"])
        {
            self.itemPro.pic_url=string;
        }
        if(![self.currentElement compare:@"price"])
        {
            self.itemPro.price=string;
        }
        if(![self.currentElement compare:@"score"])
        {
            self.itemPro.score=string;
            [self.itemProlist addObject:self.itemPro];
            [self.itemPro release];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"item_cat"])
    {
        [self.itemCatlist addObject:self.itemCat];
        [self.itemCat release];
    }
    if([elementName isEqualToString:@"itemcats_get_response"])
    {
        [self reloadTableInPage:1];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.isLoadProlist)
    { 
        Productlist *productlistView=[[Productlist alloc] init];
        ItemCategoryModel *selectedItemCat=[self.itemCatlist objectAtIndex:rowIndex];
        productlistView.itemCat=selectedItemCat;
        productlistView.itemProlist=self.itemProlist;
        [selectedItemCat release];
        [self.itemProlist release];
        
        [self.navigationController pushViewController:productlistView animated:YES];
        self.isLoadProlist=NO;
    }
}

#pragma 表格数据源和委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentCatlist count];   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ItemCatCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    ItemCategoryModel *cellItemCat=[self.currentCatlist objectAtIndex:indexPath.row];
    cell.textLabel.text=cellItemCat.name;
    cell.imageView.image=[UIImage imageNamed:@"ItemCat.png"];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

-(void)startAnimation
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.overLayer.alpha=0.4f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overLayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self.view addSubview:self.overLayer];
    self.overLayer.alpha=1.0f;
    [UIView commitAnimations];
    [pool release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    self.isLoadProlist=YES;
    rowIndex=indexPath.row;
    self.itemProlist=[[NSMutableArray alloc] init];
    ItemCategoryModel *selectedItemCat=[self.itemCatlist objectAtIndex:indexPath.row];
    
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,pic_url,price,score" forKey:@"fields"];
    [params setObject:selectedItemCat.cid forKey:@"cid"];
    NSData *resultData=[Utility getResultData:params];
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

//自定义双击Tab事件
-(void)performSegmentAction:(DoubleTapSegmentedControl *)sender
{
    if([self.itemCatlist count]>0)//获取淘宝的数据后加载
    {
        maxPage=[self.itemCatlist count]/[self.currentCatlist count];
        if([sender selectedSegmentIndex]==0)//上一页
        {
            if(currentPage>1)
            {
                PLAYEPAGESOUND;
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.tableView cache:YES];
                currentPage--;
                [self reloadTableInPage:currentPage];
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
                [self reloadTableInPage:currentPage];
                 [UIView commitAnimations];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!已经是最后一页了！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
}
@end
