//
//  Tradelist.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-18.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "TradelistView.h"


@implementation TradelistView

@synthesize overlayer;
@synthesize isloading;
@synthesize tableView;
@synthesize segController;
@synthesize currentElement;
@synthesize tradelist;
@synthesize tradeModel;

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
    [segController release];
    [currentElement release];
    [tradelist release];
    [tradeModel release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)updateCellImage:(NSIndexPath *)indexPath
{
    TradeModel *trade=[self.tradelist objectAtIndex:indexPath.row];
    TradeCell *cell=(TradeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.tradeImg.image=trade.photo;
    UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[cell.tradeImg viewWithTag:102];
    [actView stopAnimating];
    [actView removeFromSuperview];
}

-(void)downloadCellImage:(NSIndexPath *)indexPath
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    TradeModel *trade=[self.tradelist objectAtIndex:indexPath.row];
    if(trade.photo==nil)
    {
        UIImage *tmpImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:trade.pic_path]]];
        trade.photo=tmpImg;
    }
    [self performSelectorOnMainThread:@selector(updateCellImage:) withObject:indexPath waitUntilDone:YES];
    [pool release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trade_bg.jpg"]];
    img.alpha=0.4;
    self.tableView.backgroundView=img;
    [img release];
    self.navigationItem.title=@"我的订单";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView=nil;
    self.segController=nil;
    self.overlayer=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma 表格数据源和委托\等待动画

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
    return [self.tradelist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    TradeCell *cell=(TradeCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"TradeCell" owner:self options:nil];
        for(id obj in nibs)
        {
            if([obj isKindOfClass:[TradeCell class]])
            {
                cell=(TradeCell *)obj;
            }
        }
    }
    TradeModel *tradeInfo=[self.tradelist objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.tradeName.text=tradeInfo.orderModel.title;
    cell.tradePrice.text=tradeInfo.price;
    cell.tradeStatus.text=tradeInfo.status;
    cell.tradeStatus.textColor=[UIColor redColor];
    cell.tradeCreate.text=tradeInfo.created;
    
    UIActivityIndicatorView *actView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    actView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [actView startAnimating];
    actView.center=cell.tradeImg.center;
    actView.tag=102;
    [cell.tradeImg addSubview:actView];
    [actView release];
    [NSThread detachNewThreadSelector:@selector(downloadCellImage:) toTarget:self withObject:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLAYERALERTSOUND;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(isFinshed:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
    
    TradeModel *tdModel=[self.tradelist objectAtIndex:indexPath.row];
    TradeInfoView *trdInfoView=[[TradeInfoView alloc] initWithNibName:@"TradeInfoView" bundle:nil];
    trdInfoView.tradeModel=tdModel;
    [self.navigationController pushViewController:trdInfoView animated:YES];
}

@end
