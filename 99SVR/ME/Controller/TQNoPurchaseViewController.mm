//
//  TQIntroductionViewController.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//未购买的私人定制页面

#import "TQNoPurchaseViewController.h"
#import "TQIntroductCell.h"
#import "TQNoCustomHeader.h"
#import "TQPurchaseView.h"
#import "TQPurchaseViewController.h"
#import "TQNoCustomView.h"



@interface TQNoPurchaseViewController ()
/** 头部试图 */
@property (nonatomic ,weak)UIView *headerView;
/** 购买框 */
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (nonatomic ,weak)TQPurchaseView *purchaseView;
/*tablevie列表*/
@property (nonatomic ,weak) TQNoCustomView *nocustomView;
@end

@implementation TQNoPurchaseViewController
static NSString *const IntroductCell = @"IntroductCell";
#pragma mark - 点击监听
//VIP点击
//跳转购买页

<<<<<<< HEAD
=======

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupHeaderView];


}
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b
-(void)initUI {
    UILabel *title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(20)];
    title.text = @"我的私人定制";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    [self.navigationItem setTitleView:title];
<<<<<<< HEAD
    //设置头部标题
    TQNoCustomView *nocustomView = [[TQNoCustomView alloc] initWithFrame:self.view.bounds];
    self.nocustomView = nocustomView;
    [self.view addSubview:nocustomView];
    //头部视图
=======
<<<<<<< HEAD
=======
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b
    [self setupHeaderView];
    //悬停购买条
    TQPurchaseView *purchaseView = [TQPurchaseView purchaseView];
    [purchaseView.purchaseBtn addTarget:self action:@selector(purchaseViewPage) forControlEvents:UIControlEventTouchUpInside];
    purchaseView.frame = CGRectMake(10, kScreenHeight - 64, kScreenWidth - 20, 44);
    //    purchaseView.hidden = YES;
    _purchaseView = purchaseView;
<<<<<<< HEAD
    [self.view addSubview:purchaseView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
=======
    [self.tableView addSubview:purchaseView];
>>>>>>> 28295b90cd0edb89bfe377e8ead86b5c3fa796b9
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b
    

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    //添加购买条
    [self addPurchase];
}
-(void)setupHeaderView {
<<<<<<< HEAD
=======
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQIntroductCell class]) bundle:nil] forCellReuseIdentifier:IntroductCell];
    
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b
    //头部视图
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TQNoCustomHeader" owner:nil options:nil] lastObject];
    self.headerView = headerView;
<<<<<<< HEAD
    self.nocustomView.tableHeaderView = headerView;
//    headerView.frame = CGRectMake(0, 0, kScreenSourchWidth, 250);
    [headerView.questionBtn addTarget:self action:@selector(DetailsPage) forControlEvents:UIControlEventTouchUpInside];
    
    
=======
    self.tableView.tableHeaderView = headerView;
//    [headerView.questionBtn addTarget:self action:@selector(DetailsPage) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b
}
-(void)addPurchase {
    TQPurchaseView *purchaseView = [TQPurchaseView purchaseView];
    //    [purchaseView.purchaseBtn addTarget:self action:@selector(purchaseViewPage) forControlEvents:UIControlEventTouchUpInside];
    purchaseView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, 44);
//    purchaseView.hidden = YES;
    _purchaseView = purchaseView;
    [self.tableView addSubview:purchaseView];
}

<<<<<<< HEAD


=======

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQIntroductCell *cell = [tableView dequeueReusableCellWithIdentifier:IntroductCell];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!self.purchaseView.hidden) {
//        
//    CGRect frame = self.purchaseView.frame;
//    frame.origin.y = kScreenHeight;
//    self.purchaseView.frame = frame;
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    }];
//    self.purchaseView.hidden = YES;
//    }
//}

>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b

@end
