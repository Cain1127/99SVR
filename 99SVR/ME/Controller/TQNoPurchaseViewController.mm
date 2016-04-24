//
//  TQIntroductionViewController.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//未购买的私人定制页面

#import "TQNoPurchaseViewController.h"
#import "TQNoCustomHeader.h"
#import "TQIntroductCell.h"
#import "TQNoCustomHeader.h"
#import "TQPurchaseView.h"
#import "TQPurchaseViewController.h"
#import "TQNoCustomView.h"



@interface TQNoPurchaseViewController ()
/** 头部试图 */
@property (nonatomic ,weak)TQNoCustomHeader *headerView;
/** 购买框 */
@property (nonatomic ,weak)TQPurchaseView *purchaseView;
/*tablevie列表*/
@property (nonatomic ,weak) TQNoCustomView *nocustomView;
@end

@implementation TQNoPurchaseViewController
static NSString *const IntroductCell = @"IntroductCell";

-(void)initUI {
    UILabel *title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(20)];
    title.text = @"我的私人定制";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    [self.navigationItem setTitleView:title];
    //设置头部标题
    TQNoCustomView *nocustomView = [[TQNoCustomView alloc] initWithFrame:self.view.bounds];
    self.nocustomView = nocustomView;
    [self.view addSubview:nocustomView];
    //头部视图
    [self setupHeaderView];
    //悬停购买条
    TQPurchaseView *purchaseView = [TQPurchaseView purchaseView];
    [purchaseView.purchaseBtn addTarget:self action:@selector(purchaseViewPage) forControlEvents:UIControlEventTouchUpInside];
    purchaseView.frame = CGRectMake(10, kScreenHeight - 64, kScreenWidth - 20, 44);
    //    purchaseView.hidden = YES;
    _purchaseView = purchaseView;
    [self.view addSubview:purchaseView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    

}
//跳转购买页
-(void)purchaseViewPage {
    TQPurchaseViewController *purchaseVC = [[TQPurchaseViewController alloc] init];
    [self.navigationController pushViewController:purchaseVC animated:YES];
    
}
//跳转详情页
-(void)DetailsPage {
    
}


-(void)setupHeaderView {
    //头部视图
    TQNoCustomHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TQNoCustomHeader" owner:nil options:nil] lastObject];
    self.headerView = headerView;
    self.nocustomView.tableHeaderView = headerView;
//    headerView.frame = CGRectMake(0, 0, kScreenSourchWidth, 250);
    [headerView.questionBtn addTarget:self action:@selector(DetailsPage) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}




@end
