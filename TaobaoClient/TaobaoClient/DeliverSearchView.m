//
//  DeliverSearchView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "DeliverSearchView.h"


@implementation DeliverSearchView

@synthesize currentElement;
@synthesize overlayer;
@synthesize tableView;
@synthesize scrollView;
@synthesize searchBar;
@synthesize isloading;
@synthesize delModel;
@synthesize kuaidilist;
@synthesize resultMessage;

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
    [scrollView release];
    [resultMessage release];
    [kuaidilist release];
    [delModel release];
    [overlayer release];
    [tableView release];
    [searchBar release];
    [currentElement release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dismissOverlayer
{
    [self.overlayer removeFromSuperview];
}

//查询物流按钮事件
//注意订单只能是数字
//http://kuaidi100.youshang.com/api.html
//这里使用的是免费的单次最新结果查询，若需要多次周转可以申请
-(IBAction)searchDetail:(id)sender
{
    PLAYBUTTONSOUND;
    [self.searchBar resignFirstResponder];
    if([self.searchBar.text isEqualToString:@""]||(self.searchBar.text==nil))
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"物流号不能为空！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.kuaidiParams==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择一个物流公司" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    self.isloading=YES;
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    
    NSString *urlString=@"http://api.kuaidi100.com/apione?";
    NSString *bodyString=[NSString stringWithFormat:@"com=%@&nu=%@&show=1",[appDelegate.kuaidiParams objectForKey:@"value"],self.searchBar.text];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [theRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *resultData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:resultData] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}


#pragma mark - View lifecycle


//更新选中的物流公司
-(void)viewWillAppear:(BOOL)animated
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.kuaidiParams!=nil)
    {
        UITableViewCell *cell=(UITableViewCell *)[self.tableView viewWithTag:101];
        cell.detailTextLabel.text=[appDelegate.kuaidiParams objectForKey:@"key"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"物流查询小工具";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(searchDetail:)]autorelease];
     self.isloading=NO;
    CGSize newSize=CGSizeMake(320, 260);
    self.scrollView.contentSize=newSize;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView=nil;
    self.resultMessage=nil;
    self.overlayer=nil;
    self.searchBar=nil;
    self.tableView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma XML解析，获取物流单号的周转信息

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([elementName isEqualToString:@"message"])
    {
        self.kuaidilist=[[[NSMutableArray alloc] init] autorelease];
    }
    if([elementName isEqualToString:@"data"])
    {
        self.delModel=[[KuaiDi100Model alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"time"])
    {
        self.delModel.time=string;
    }
    if([self.currentElement isEqualToString:@"context"])
    {
        self.delModel.context=string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"data"])
    {
        [self.kuaidilist addObject:self.delModel];
        [self.delModel release];
    }
}

-(void)updateMessage
{
    NSString *message=@"";
    for(KuaiDi100Model *k in self.kuaidilist)
    {
        message=[message stringByAppendingFormat:@"%@%@\n",k.time,k.context];
    }
    self.resultMessage.text=message;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.isloading=NO;
    [self performSelectorOnMainThread:@selector(updateMessage) withObject:nil waitUntilDone:YES];
}

#pragma 表格数据源和委托、等待动画

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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry！未查询到该物流订单，请确保您的输入正确！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
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

-(void)updateStart
{
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
}

-(void)startAnimation
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [self performSelectorOnMainThread:@selector(updateStart) withObject:nil waitUntilDone:YES];
    [pool release];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CompanyCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=@"请选择物流公司";
    cell.tag=101;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CompanyView *compViewController=[[CompanyView alloc] initWithNibName:@"CompanyView" bundle:nil];
    UINavigationController *navViewController=[[UINavigationController alloc] initWithRootViewController:compViewController];
    [self presentModalViewController:navViewController animated:YES];
    [compViewController release];
}

@end
