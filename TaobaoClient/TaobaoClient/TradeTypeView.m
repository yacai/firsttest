//
//  TradeTypeView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-22.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TradeTypeView.h"


@implementation TradeTypeView

@synthesize isloading;
@synthesize overlayer;
@synthesize tradeTypes;
@synthesize tableView;
@synthesize tradelist;
@synthesize paylist;
@synthesize deliverlist;
@synthesize confirmlist;
@synthesize closelist;

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
    [tradelist release];
    [paylist release];
    [deliverlist release];
    [confirmlist release];
    [closelist release];
    [tableView release];
    [tradeTypes release];
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
    
    UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tradeType_bg.jpg"]];
    bgImgView.alpha=0.3f;
    self.tableView.backgroundView=bgImgView;
    [bgImgView release];
    
    self.navigationItem.title=@"我的订单";
    self.tradeTypes=[[[NSMutableArray alloc] init] autorelease];
    
    NSMutableDictionary *allTrade=[[NSMutableDictionary alloc] init];
    [allTrade setObject:@"所有订单" forKey:@"name"];
    UIImage *allImg=[UIImage imageNamed:@"trade_all.png"];
    [allTrade setObject:allImg forKey:@"image"];
    [self.tradeTypes addObject:allTrade];
    [allTrade release];
    
    NSMutableDictionary *waitPay=[[NSMutableDictionary alloc] init];
    UIImage *waitPayImg=[UIImage imageNamed:@"trade_pay.png"];
    [waitPay setObject:waitPayImg forKey:@"image"];
    [waitPay setObject:@"待付款" forKey:@"name"];
    [self.tradeTypes addObject:waitPay];
    [waitPay release];
    
    NSMutableDictionary *waitSend=[[NSMutableDictionary alloc] init];
    UIImage *waitSendImg=[UIImage imageNamed:@"trade_send.png"];
    [waitSend setObject:waitSendImg forKey:@"image"];
    [waitSend setObject:@"待发货" forKey:@"name"];
    [self.tradeTypes addObject:waitSend];
    [waitSend release];
    
    NSMutableDictionary *waitConfirm=[[NSMutableDictionary alloc] init];
    UIImage *watConfirmImg=[UIImage imageNamed:@"trade_confirm.png"];
    [waitConfirm setObject:watConfirmImg forKey:@"image"];
    [waitConfirm setObject:@"待确认收货" forKey:@"name"];
    [self.tradeTypes addObject:waitConfirm];
    [waitConfirm release];

    NSMutableDictionary *tradeClose=[[NSMutableDictionary alloc] init];
    UIImage *closeImg=[UIImage imageNamed:@"trade_close.png"];
    [tradeClose setObject:closeImg forKey:@"image"];
    [tradeClose setObject:@"退款订单" forKey:@"name"];
    [self.tradeTypes addObject:tradeClose];
    [tradeClose release];
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

#pragma 表格数据源、委托和等待动画

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tradeTypes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"TypeCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
    }
    NSMutableDictionary *type=[self.tradeTypes objectAtIndex:indexPath.row];
    cell.imageView.image=[type objectForKey:@"image"];
    cell.textLabel.text=[type objectForKey:@"name"];
    if(indexPath.row==0)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[self.tradelist count]];
    }
    if(indexPath.row==1)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[self.paylist count]];
    }
    if(indexPath.row==2)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[self.deliverlist count]];
    }
    if(indexPath.row==3)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[self.confirmlist count]];
    }
    if(indexPath.row==4)
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[self.closelist count]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    TradelistView *tradesView=[[TradelistView alloc] initWithNibName:@"TradelistView" bundle:nil];
    if(indexPath.row==0)//所有订单
    {
        tradesView.tradelist=self.tradelist;
    }
    else if(indexPath.row==1)//待付款
    {
        tradesView.tradelist=self.paylist;
    }
    else if(indexPath.row==2)//待发货
    {
       tradesView.tradelist=self.deliverlist;
    }
    else if(indexPath.row==3)//待确认收货
    {
        tradesView.tradelist=self.confirmlist;
    }
    else                    //退款订单
    {
        tradesView.tradelist=self.closelist;
    }
    [self.navigationController pushViewController:tradesView animated:YES];
}

@end
