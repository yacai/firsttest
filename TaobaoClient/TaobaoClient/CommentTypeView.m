//
//  CommentView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CommentTypeView.h"


@implementation CommentTypeView

@synthesize overlayer;
@synthesize isloading;
@synthesize tableView;
@synthesize commModel;
@synthesize currentElement;
@synthesize datalist;
@synthesize goodlist;
@synthesize neutrallist;
@synthesize badlist;
@synthesize commentType;

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
    [commentType release];
    [badlist release];
    [commModel release];
    [currentElement release];
    [neutrallist release];
    [goodlist release];
    [datalist release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//下载所有的给出评论
-(void)loadComments
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.datalist=[[[NSMutableArray alloc]init]autorelease];
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.traderates.get" forKey:@"method"];
    [params setObject:@"tid,nick,created,rated_nick,item_title,item_price,content,result" forKey:@"fields"];
    [params setObject:@"buyer" forKey:@"role"];
    [params setObject:@"give" forKey:@"rate_type"];
    [params setObject:self.commentType forKey:@"result"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"评价管理";
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

#pragma 表格数据源和动画

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

#pragma 表格数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ResultCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.row==0)
    {
        cell.textLabel.text=@"好评";
        cell.imageView.image=[UIImage imageNamed:@"comment_good.png"];
    }
    if(indexPath.row==1)
    {
        cell.textLabel.text=@"中评";
        cell.imageView.image=[UIImage imageNamed:@"comment_neutral.png"];
    }
    if(indexPath.row==2)
    {
        cell.textLabel.text=@"差评";
        cell.imageView.image=[UIImage imageNamed:@"comment_bad.png"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    if(indexPath.row==0)//好评
    {
        self.commentType=@"good";
    }
    else if(indexPath.row==1)//中评
    {
        self.commentType=@"neutral";
    }
    else//差评
    {
        self.commentType=@"bad";
    }
    [self loadComments];
}

#pragma 解析XML，得到特定种类的评论列表

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"traderates_get_response"])
    {
        self.goodlist=[[[NSMutableArray alloc]init] autorelease];
    }
    if([elementName isEqualToString:@"trade_rate"])
    {
        self.commModel=[[CommentModel alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"content"])
    {
        self.commModel.content=string;
    }
    if([self.currentElement isEqualToString:@"created"])
    {
        self.commModel.created=string;
    }
    if([self.currentElement isEqualToString:@"item_price"])
    {
        self.commModel.item_price=string;
    }
    if([self.currentElement isEqualToString:@"item_title"])
    {
        self.commModel.item_title=string;
    }
    if([self.currentElement isEqualToString:@"nick"])
    {
        self.commModel.nick=string;
    }
    if([self.currentElement isEqualToString:@"rated_nick"])
    {
        self.commModel.rated_nick=string;
    }
    if([self.currentElement isEqualToString:@"result"])
    {
        self.commModel.result=string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"trade_rate"])
    {
        [self.goodlist addObject:self.commModel];
        [self.commModel release];
    }
    if([elementName isEqualToString:@"traderates_get_response"])
    {
        CommentlistView *commlistView=[[CommentlistView alloc] initWithNibName:@"CommentlistView" bundle:nil];
        commlistView.commentType=self.commentType;
        commlistView.commentlist=self.goodlist;
        [self.navigationController pushViewController:commlistView animated:YES];
    }
}

@end
