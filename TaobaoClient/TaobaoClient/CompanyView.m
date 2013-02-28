//
//  CompanyView.m
//  TaobaoClient
//
//  Created by 韩 国翔 on 11-11-23.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "CompanyView.h"


@implementation CompanyView

@synthesize picker;
@synthesize serlist;
@synthesize derlist;
@synthesize inputfield;

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
    [inputfield release];
    [serlist release];
    [derlist release];
    [picker release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)doneAction
{
    PLAYBUTTONSOUND;
    if([self.derlist count]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请至少选择一个物流快递" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *params=[self.derlist objectAtIndex:[self.picker selectedRowInComponent:0]];
    appDelegate.kuaidiParams=params;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)cancelAction
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegate respondsToSelector:@selector(loadButtonSound:)])
    {
        PLAYBUTTONSOUND;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)inputFinished:(id)sender
{
    [self.inputfield resignFirstResponder];
}

//查看所有物流公司
-(IBAction)showALLAction:(id)sender
{
    PLAYBUTTONSOUND;
    self.derlist=[self.serlist mutableCopy];
    [self.picker reloadComponent:0];
}

//搜索物流公司
//汉子存储后是字母，无法排序和正常搜索
-(IBAction)searchAction:(id)sender
{
    PLAYBUTTONSOUND;
    [self inputFinished:sender];
    if([self.inputfield.text isEqualToString:@""]||self.inputfield.text==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"物流公司名称不鞥为空!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [self.derlist removeAllObjects];
    for(NSMutableDictionary *param  in self.serlist)
    {
        NSString *key=[param objectForKey:@"key"];
        NSRange range=[key rangeOfString:self.inputfield.text];
        if((range.location>=0)&&(range.location<=4))
        {
            [self.derlist addObject:param];
        }
    }
    [self.picker reloadComponent:0];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    TaobaoClientAppDelegate *appDelegate=(TaobaoClientAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.kuaidiParams!=nil)
    {
        NSUInteger row=[self.derlist indexOfObject:appDelegate.kuaidiParams];
        [self.picker selectRow:row inComponent:0 animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"物流公司";
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)] autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)]autorelease];
    
    self.serlist=[[[NSMutableArray alloc]init]autorelease];
    self.derlist=[[[NSMutableArray alloc] init] autorelease];
    
    NSMutableDictionary *parm1=[[NSMutableDictionary alloc] init];
    [parm1 setObject:[NSString stringWithCString:"AAE全球专递" encoding:NSUTF8StringEncoding] forKey:@"key"];
    [parm1 setObject:@"aae" forKey:@"value"];
    [self.derlist addObject:parm1];
    [parm1 release];
    
    NSMutableDictionary *parm2=[[NSMutableDictionary alloc] init];
    [parm2 setObject:@"安捷快递" forKey:@"key"];
    [parm2 setObject:@"anjiekuaidi" forKey:@"value"];
    [self.derlist addObject:parm2];
    [parm2 release];

    NSMutableDictionary *parm3=[[NSMutableDictionary alloc] init];
    [parm3 setObject:@"安信达快递" forKey:@"key"];
    [parm3 setObject:@"anxindakuaixi" forKey:@"value"];
    [self.derlist addObject:parm3];
    [parm3 release];
    
    NSMutableDictionary *parm4=[[NSMutableDictionary alloc] init];
    [parm4 setObject:@"百福东方" forKey:@"key"];
    [parm4 setObject:@"baifudongfang" forKey:@"value"];
    [self.derlist addObject:parm4];
    [parm4 release];
    
    NSMutableDictionary *parm5=[[NSMutableDictionary alloc] init];
    [parm5 setObject:@"中通速递" forKey:@"key"];
    [parm5 setObject:@"zhongtong" forKey:@"value"];
    [self.derlist addObject:parm5];
    [parm5 release];

    NSMutableDictionary *parm6=[[NSMutableDictionary alloc] init];
    [parm6 setObject:@"EMS快递" forKey:@"key"];
    [parm6 setObject:@"ems" forKey:@"value"];
    [self.derlist addObject:parm6];
    [parm6 release];
    
    NSMutableDictionary *parm7=[[NSMutableDictionary alloc] init];
    [parm7 setObject:@"申通快递" forKey:@"key"];
    [parm7 setObject:@"shentong" forKey:@"value"];
    [self.derlist addObject:parm7];
    [parm7 release];
    
    NSMutableDictionary *parm8=[[NSMutableDictionary alloc] init];
    [parm8 setObject:@"圆通速递" forKey:@"key"];
    [parm8 setObject:@"yuantong" forKey:@"value"];
    [self.derlist addObject:parm8];
    [parm8 release];
    
    NSMutableDictionary *parm9=[[NSMutableDictionary alloc] init];
    [parm9 setObject:@"韵达快运" forKey:@"key"];
    [parm9 setObject:@"yunda" forKey:@"value"];
    [self.derlist addObject:parm9];
    [parm9 release];	

    NSMutableDictionary *parm10=[[NSMutableDictionary alloc] init];
    [parm10 setObject:@"中铁快运" forKey:@"key"];
    [parm10 setObject:@"ztky" forKey:@"value"];
    [self.derlist addObject:parm10];
    [parm10 release];
	
    NSMutableDictionary *parm11=[[NSMutableDictionary alloc] init];
    [parm11 setObject:@"彪记快递" forKey:@"key"];
    [parm11 setObject:@"biaojikuaidi" forKey:@"value"];
    [self.derlist addObject:parm11];
    [parm11 release];

    NSMutableDictionary *parm12=[[NSMutableDictionary alloc] init];
    [parm12 setObject:@"BHT" forKey:@"key"];
    [parm12 setObject:@"bht" forKey:@"value"];
    [self.derlist addObject:parm12];
    [parm12 release];
    
    NSMutableDictionary *parm13=[[NSMutableDictionary alloc] init];
    [parm13 setObject:@"希伊艾斯快递" forKey:@"key"];
    [parm13 setObject:@"cces" forKey:@"value"];
    [self.derlist addObject:parm13];
    [parm13 release];
    
    NSMutableDictionary *parm14=[[NSMutableDictionary alloc] init];
    [parm14 setObject:@"中国东方（COE）" forKey:@"key"];
    [parm14 setObject:@"coe" forKey:@"value"];
    [self.derlist addObject:parm14];
    [parm14 release];
    
    NSMutableDictionary *parm15=[[NSMutableDictionary alloc] init];
    [parm15 setObject:@"长宇物流" forKey:@"key"];
    [parm15 setObject:@"changyuwuliu" forKey:@"value"];
    [self.derlist addObject:parm15];
    [parm15 release];
    	
    NSMutableDictionary *parm16=[[NSMutableDictionary alloc] init];
    [parm16 setObject:@"大田物流" forKey:@"key"];
    [parm16 setObject:@"datianwuliu" forKey:@"value"];
    [self.derlist addObject:parm16];
    [parm16 release];
    
    NSMutableDictionary *parm17=[[NSMutableDictionary alloc] init];
    [parm17 setObject:@"德邦物流" forKey:@"key"];
    [parm17 setObject:@"debangwuliu" forKey:@"value"];
    [self.derlist addObject:parm17];
    [parm17 release];
    
    NSMutableDictionary *parm18=[[NSMutableDictionary alloc] init];
    [parm18 setObject:@"DPEX" forKey:@"key"];
    [parm18 setObject:@"dpex" forKey:@"value"];
    [self.derlist addObject:parm18];
    [parm18 release];
    
    NSMutableDictionary *parm19=[[NSMutableDictionary alloc] init];
    [parm19 setObject:@"DHL" forKey:@"key"];
    [parm19 setObject:@"dhl" forKey:@"value"];
    [self.derlist addObject:parm19];
    [parm19 release];

    
    NSMutableDictionary *parm20=[[NSMutableDictionary alloc] init];
    [parm20 setObject:@"D速快递" forKey:@"key"];
    [parm20 setObject:@"dsukuaidi" forKey:@"value"];
    [self.derlist addObject:parm20];
    [parm20 release];
    
    NSMutableDictionary *parm21=[[NSMutableDictionary alloc] init];
    [parm21 setObject:@"fedex" forKey:@"key"];
    [parm21 setObject:@"fedex" forKey:@"value"];
    [self.derlist addObject:parm21];
    [parm21 release];
    
    NSMutableDictionary *parm22=[[NSMutableDictionary alloc] init];
    [parm22 setObject:@"D飞康达物流" forKey:@"key"];
    [parm22 setObject:@"feikangda" forKey:@"value"];
    [self.derlist addObject:parm22];
    [parm22 release];
    
    NSMutableDictionary *parm23=[[NSMutableDictionary alloc] init];
    [parm23 setObject:@"凤凰快递" forKey:@"key"];
    [parm23 setObject:@"fenghuangkuaidi" forKey:@"value"];
    [self.derlist addObject:parm23];
    [parm23 release];
    
    NSMutableDictionary *parm24=[[NSMutableDictionary alloc] init];
    [parm24 setObject:@"GLS国际快递" forKey:@"key"];
    [parm24 setObject:@"gls" forKey:@"value"];
    [self.derlist addObject:parm24];
    [parm24 release];
    
    NSMutableDictionary *parm25=[[NSMutableDictionary alloc] init];
    [parm25 setObject:@"广东邮政物流" forKey:@"key"];
    [parm25 setObject:@"guangdongyouzhengwuliu" forKey:@"value"];
    [self.derlist addObject:parm25];
    [parm25 release];
    
    NSMutableDictionary *parm26=[[NSMutableDictionary alloc] init];
    [parm26 setObject:@"汇通快运" forKey:@"key"];
    [parm26 setObject:@"huitongkuaidi" forKey:@"value"];
    [self.derlist addObject:parm26];
    [parm26 release];
    
    NSMutableDictionary *parm27=[[NSMutableDictionary alloc] init];
    [parm27 setObject:@"恒路物流" forKey:@"key"];
    [parm27 setObject:@"hengluwuliu" forKey:@"value"];
    [self.derlist addObject:parm27];
    [parm27 release];
    
    NSMutableDictionary *parm28=[[NSMutableDictionary alloc] init];
    [parm28 setObject:@"华夏龙物流" forKey:@"key"];
    [parm28 setObject:@"huaxialongwuliu" forKey:@"value"];
    [self.derlist addObject:parm28];
    [parm28 release];
    
    NSMutableDictionary *parm29=[[NSMutableDictionary alloc] init];
    [parm29 setObject:@"佳怡物流" forKey:@"key"];
    [parm29 setObject:@"jiayiwuliu" forKey:@"value"];
    [self.derlist addObject:parm29];
    [parm29 release];
    
    NSMutableDictionary *parm30=[[NSMutableDictionary alloc] init];
    [parm30 setObject:@"京广速递" forKey:@"key"];
    [parm30 setObject:@"jinguangsudikuaijian" forKey:@"value"];
    [self.derlist addObject:parm30];
    [parm30 release];
    
    NSMutableDictionary *parm31=[[NSMutableDictionary alloc] init];
    [parm31 setObject:@"急先达" forKey:@"key"];
    [parm31 setObject:@"jixianda" forKey:@"value"];
    [self.derlist addObject:parm31];
    [parm31 release];
    
    NSMutableDictionary *parm32=[[NSMutableDictionary alloc] init];
    [parm32 setObject:@"佳吉物流" forKey:@"key"];
    [parm32 setObject:@"jiajiwuliu" forKey:@"value"];
    [self.derlist addObject:parm32];
    [parm32 release];
    
    NSMutableDictionary *parm33=[[NSMutableDictionary alloc] init];
    [parm33 setObject:@"加运美" forKey:@"key"];
    [parm33 setObject:@"jiayunmeiwuliu" forKey:@"value"];
    [self.derlist addObject:parm33];
    [parm33 release];

    
    NSMutableDictionary *parm34=[[NSMutableDictionary alloc] init];
    [parm34 setObject:@"快捷速递" forKey:@"key"];
    [parm34 setObject:@"kuaijiesudi" forKey:@"value"];
    [self.derlist addObject:parm34];
    [parm34 release];

    
    NSMutableDictionary *parm35=[[NSMutableDictionary alloc] init];
    [parm35 setObject:@"联昊通物流" forKey:@"key"];
    [parm35 setObject:@"lianhaowuliu" forKey:@"value"];
    [self.derlist addObject:parm35];
    [parm35 release];
    
    NSMutableDictionary *parm36=[[NSMutableDictionary alloc] init];
    [parm36 setObject:@"龙邦物流" forKey:@"key"];
    [parm36 setObject:@"longbanwuliu" forKey:@"value"];
    [self.derlist addObject:parm36];
    [parm36 release];
    
    NSMutableDictionary *parm37=[[NSMutableDictionary alloc] init];
    [parm37 setObject:@"蓝镖快递" forKey:@"key"];
    [parm37 setObject:@"lanbiaokuaidi" forKey:@"value"];
    [self.derlist addObject:parm37];
    [parm37 release];

    NSMutableDictionary *parm38=[[NSMutableDictionary alloc] init];
    [parm38 setObject:@"民航快递" forKey:@"key"];
    [parm38 setObject:@"minghangkuaidi" forKey:@"value"];
    [self.derlist addObject:parm38];
    [parm38 release];
    
    NSMutableDictionary *parm39=[[NSMutableDictionary alloc] init];
    [parm39 setObject:@"蓝镖快递" forKey:@"key"];
    [parm39 setObject:@"lanbiaokuaidi" forKey:@"value"];
    [self.derlist addObject:parm39];
    [parm39 release];
    
    NSMutableDictionary *parm40=[[NSMutableDictionary alloc] init];
    [parm40 setObject:@"配思货运" forKey:@"key"];
    [parm40 setObject:@"peisihuoyunkuaidi" forKey:@"value"];
    [self.derlist addObject:parm40];
    [parm40 release];
    
    NSMutableDictionary *parm41=[[NSMutableDictionary alloc] init];
    [parm41 setObject:@"全晨快递" forKey:@"key"];
    [parm41 setObject:@"quanchenkuaidi" forKey:@"value"];
    [self.derlist addObject:parm41];
    [parm41 release];
    
    NSMutableDictionary *parm42=[[NSMutableDictionary alloc] init];
    [parm42 setObject:@"全际通物流" forKey:@"key"];
    [parm42 setObject:@"quanjitong" forKey:@"value"];
    [self.derlist addObject:parm42];
    [parm42 release];
    
    NSMutableDictionary *parm43=[[NSMutableDictionary alloc] init];
    [parm43 setObject:@"全日通快递" forKey:@"key"];
    [parm43 setObject:@"quanritongkuaidi" forKey:@"value"];
    [self.derlist addObject:parm43];
    [parm43 release];
    
    NSMutableDictionary *parm44=[[NSMutableDictionary alloc] init];
    [parm44 setObject:@"全一快递" forKey:@"key"];
    [parm44 setObject:@"quanyikuaidi" forKey:@"value"];
    [self.derlist addObject:parm44];
    [parm44 release];
    
    NSMutableDictionary *parm45=[[NSMutableDictionary alloc] init];
    [parm45 setObject:@"三态速递" forKey:@"key"];
    [parm45 setObject:@"shunfeng" forKey:@"value"];
    [self.derlist addObject:parm45];
    [parm45 release];
    
    NSMutableDictionary *parm46=[[NSMutableDictionary alloc] init];
    [parm46 setObject:@"盛辉物流" forKey:@"key"];
    [parm46 setObject:@"shenghuiwuliu" forKey:@"value"];
    [self.derlist addObject:parm46];
    [parm46 release];

    
    NSMutableDictionary *parm47=[[NSMutableDictionary alloc] init];
    [parm47 setObject:@"三态速递" forKey:@"key"];
    [parm47 setObject:@"santaisudi" forKey:@"value"];
    [self.derlist addObject:parm47];
    [parm47 release];

    
    NSMutableDictionary *parm48=[[NSMutableDictionary alloc] init];
    [parm48 setObject:@"速尔物流" forKey:@"key"];
    [parm48 setObject:@"suer" forKey:@"value"];
    [self.derlist addObject:parm48];
    [parm48 release];
    
    NSMutableDictionary *parm49=[[NSMutableDictionary alloc] init];
    [parm49 setObject:@"盛丰物流" forKey:@"key"];
    [parm49 setObject:@"shengfengwuliu" forKey:@"value"];
    [self.derlist addObject:parm49];
    [parm49 release];
    
    NSMutableDictionary *parm50=[[NSMutableDictionary alloc] init];
    [parm50 setObject:@"上大物流" forKey:@"key"];
    [parm50 setObject:@"shangda" forKey:@"value"];
    [self.derlist addObject:parm50];
    [parm50 release];
    
    NSMutableDictionary *parm51=[[NSMutableDictionary alloc] init];
    [parm51 setObject:@"天地华宇" forKey:@"key"];
    [parm51 setObject:@"tiandihuayu" forKey:@"value"];
    [self.derlist addObject:parm51];
    [parm51 release];
    
    NSMutableDictionary *parm52=[[NSMutableDictionary alloc] init];
    [parm52 setObject:@"天天快递" forKey:@"key"];
    [parm52 setObject:@"tiantian" forKey:@"value"];
    [self.derlist addObject:parm52];
    [parm52 release];
    
    NSMutableDictionary *parm53=[[NSMutableDictionary alloc] init];
    [parm53 setObject:@"TNT" forKey:@"key"];
    [parm53 setObject:@"tnt" forKey:@"value"];
    [self.derlist addObject:parm53];
    [parm53 release];
    
    NSMutableDictionary *parm54=[[NSMutableDictionary alloc] init];
    [parm54 setObject:@"UPS" forKey:@"key"];
    [parm54 setObject:@"ups" forKey:@"value"];
    [self.derlist addObject:parm54];
    [parm54 release];
    
    NSMutableDictionary *parm55=[[NSMutableDictionary alloc] init];
    [parm55 setObject:@"万家物流" forKey:@"key"];
    [parm55 setObject:@"wanjiawuliu" forKey:@"value"];
    [self.derlist addObject:parm55];
    [parm55 release];
    
    NSMutableDictionary *parm56=[[NSMutableDictionary alloc] init];
    [parm56 setObject:@"文捷航空速递" forKey:@"key"];
    [parm56 setObject:@"wenjiesudi" forKey:@"value"];
    [self.derlist addObject:parm56];
    [parm56 release];

    
    NSMutableDictionary *parm57=[[NSMutableDictionary alloc] init];
    [parm57 setObject:@"伍圆速递" forKey:@"key"];
    [parm57 setObject:@"wuyuansudi" forKey:@"value"];
    [self.derlist addObject:parm57];
    [parm57 release];

    NSMutableDictionary *parm58=[[NSMutableDictionary alloc] init];
    [parm58 setObject:@"万象物流" forKey:@"key"];
    [parm58 setObject:@"wanxiangwuliu" forKey:@"value"];
    [self.derlist addObject:parm58];
    [parm58 release];
    
    NSMutableDictionary *parm59=[[NSMutableDictionary alloc] init];
    [parm59 setObject:@"新邦物流" forKey:@"key"];
    [parm59 setObject:@"xinbangwuliu" forKey:@"value"];
    [self.derlist addObject:parm59];
    [parm59 release];
    
    NSMutableDictionary *parm60=[[NSMutableDictionary alloc] init];
    [parm60 setObject:@"信丰物流" forKey:@"key"];
    [parm60 setObject:@"xinfengwuliu" forKey:@"value"];
    [self.derlist addObject:parm60];
    [parm60 release];
    
    NSMutableDictionary *parm61=[[NSMutableDictionary alloc] init];
    [parm61 setObject:@"星晨急便" forKey:@"key"];
    [parm61 setObject:@"xingchengjibian" forKey:@"value"];
    [self.derlist addObject:parm61];
    [parm61 release];
    
    NSMutableDictionary *parm62=[[NSMutableDictionary alloc] init];
    [parm62 setObject:@"鑫飞鸿物流快递" forKey:@"key"];
    [parm62 setObject:@"xinhongyukuaidi" forKey:@"value"];
    [self.derlist addObject:parm62];
    [parm62 release];
    
    NSMutableDictionary *parm63=[[NSMutableDictionary alloc] init];
    [parm63 setObject:@"亚风速递" forKey:@"key"];
    [parm63 setObject:@"yafengsudi" forKey:@"value"];
    [self.derlist addObject:parm63];
    [parm63 release];
    
    NSMutableDictionary *parm64=[[NSMutableDictionary alloc] init];
    [parm64 setObject:@"一邦速递" forKey:@"key"];
    [parm64 setObject:@"yibangwuliu" forKey:@"value"];
    [self.derlist addObject:parm64];
    [parm64 release];
    
    NSMutableDictionary *parm65=[[NSMutableDictionary alloc] init];
    [parm65 setObject:@"优速物流" forKey:@"key"];
    [parm65 setObject:@"youshuwuliu" forKey:@"value"];
    [self.derlist addObject:parm65];
    [parm65 release];
    
    NSMutableDictionary *parm66=[[NSMutableDictionary alloc] init];
    [parm66 setObject:@"远成物流" forKey:@"key"];
    [parm66 setObject:@"yuanchengwuliu" forKey:@"value"];
    [self.derlist addObject:parm66];
    [parm66 release];
    
    NSMutableDictionary *parm67=[[NSMutableDictionary alloc] init];
    [parm67 setObject:@"源伟丰快递" forKey:@"key"];
    [parm67 setObject:@"yuanweifeng" forKey:@"value"];
    [self.derlist addObject:parm67];
    [parm67 release];
    
    NSMutableDictionary *parm68=[[NSMutableDictionary alloc] init];
    [parm68 setObject:@"元智捷诚快递" forKey:@"key"];
    [parm68 setObject:@"yuanzhijiecheng" forKey:@"value"];
    [self.derlist addObject:parm68];
    [parm68 release];
    
    NSMutableDictionary *parm69=[[NSMutableDictionary alloc] init];
    [parm69 setObject:@"越丰物流" forKey:@"key"];
    [parm69 setObject:@"yuefengwuliu" forKey:@"value"];
    [self.derlist addObject:parm69];
    [parm69 release];
    
    NSMutableDictionary *parm70=[[NSMutableDictionary alloc] init];
    [parm70 setObject:@"源安达" forKey:@"key"];
    [parm70 setObject:@"yuananda" forKey:@"value"];
    [self.derlist addObject:parm70];
    [parm70 release];
    
    NSMutableDictionary *parm71=[[NSMutableDictionary alloc] init];
    [parm71 setObject:@"运通快递" forKey:@"key"];
    [parm71 setObject:@"Yuntongkuaidi" forKey:@"value"];
    [self.derlist addObject:parm71];
    [parm71 release];
    
    NSMutableDictionary *parm72=[[NSMutableDictionary alloc] init];
    [parm72 setObject:@"宅急送" forKey:@"key"];
    [parm72 setObject:@"zhaijisong" forKey:@"value"];
    [self.derlist addObject:parm72];
    [parm72 release];
    
    NSMutableDictionary *parm73=[[NSMutableDictionary alloc] init];
    [parm73 setObject:@"中邮物流" forKey:@"key"];
    [parm73 setObject:@"zhongyouwuliu" forKey:@"value"];
    [self.derlist addObject:parm73];
    [parm73 release];

   	
    NSSortDescriptor *sortDescriptor;  
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES] autorelease];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    NSArray *sortedArray;  
    sortedArray = [self.derlist sortedArrayUsingDescriptors:sortDescriptors];
    self.derlist=[NSMutableArray arrayWithArray:sortedArray];
    self.serlist=[self.derlist mutableCopy];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.picker=nil;
    self.inputfield=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.derlist count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableDictionary *company=[self.derlist objectAtIndex:row];
    return [company objectForKey:@"key"];
}
@end
