//
//  CommentlistView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CommentlistView.h"


@implementation CommentlistView

@synthesize overlayer;
@synthesize isloading;
@synthesize tableView;
@synthesize commentlist;
@synthesize commentType;
@synthesize commModel;
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
    [overlayer release];
    [currentElement release];
    [commModel release];
    [commentType release];
    [commentlist release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    DoubleTapSegmentedControl *segController=[[DoubleTapSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"我对别人的评价",@"别人对我的评价",nil]];
    segController.delegate=self;
    segController.segmentedControlStyle=UISegmentedControlStyleBar;
    segController.selectedSegmentIndex=0;
    self.navigationItem.titleView=segController;
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

#pragma 表格委托和数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CommentCell";
    CommentCell *cell=(CommentCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        NSArray *objs=[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        for(id obj in objs)
        {
            if([obj isKindOfClass:[CommentCell class]])
            {
                cell=(CommentCell *)obj;
            }
        }
    }
    CommentModel *commInfo=[self.commentlist objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.item_title.text=commInfo.item_title;
    cell.item_create.text=commInfo.created;
    cell.item_content.text=commInfo.content;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    CommentModel *selectedComm=[self.commentlist objectAtIndex:indexPath.row];
    CommentInfoView *commInfoView=[[CommentInfoView alloc] initWithNibName:@"CommentInfoView" bundle:nil];
    commInfoView.commModel=selectedComm;
    [self.navigationController pushViewController:commInfoView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma 解析XML，得到特定种类的评论列表

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"traderates_get_response"])
    {
        self.commentlist=[[[NSMutableArray alloc]init] autorelease];
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
        [self.commentlist addObject:self.commModel];
        [self.commModel release];
    }
    if([elementName isEqualToString:@"traderates_get_response"])
    {
        [self.tableView reloadData];
    }
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

//加载评论列表  0我对别人的评价   1别人对我的评价
-(void)performSegmentAction:(DoubleTapSegmentedControl *)sender
{
    PLAYBUTTONSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.commentlist=[[[NSMutableArray alloc]init]autorelease];
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"taobao.traderates.get" forKey:@"method"];
    [params setObject:@"tid,nick,created,rated_nick,item_title,item_price,content,result" forKey:@"fields"];
    [params setObject:@"buyer" forKey:@"role"];
    if([sender selectedSegmentIndex]==0)
    {
        [params setObject:@"give" forKey:@"rate_type"];
    }
    else
    {
        [params setObject:@"get" forKey:@"rate_type"];
    }
    [params setObject:self.commentType forKey:@"result"];
    [params setObject:appDelegate.sessionKey forKey:@"session"];
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}
@end
