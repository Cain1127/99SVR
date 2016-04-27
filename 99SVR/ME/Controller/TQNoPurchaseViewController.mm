//
//  TQIntroductionViewController.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//未购买的私人定制页面

#import "TQNoPurchaseViewController.h"
//#import "TQIntroductCell.h"
//#import "TQPurchaseView.h"
//#import "TQPurchaseViewController.h"
//#import "TQNoCustomView.h"


@interface TQNoPurchaseViewController ()
/** 头部试图 */
@property (nonatomic ,weak)UIView *headerView;
/** 购买框 */
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
//@property (nonatomic ,weak) TQPurchaseView *purchaseView;
/*tablevie列表*/
//@property (nonatomic ,weak) TQNoCustomView *nocustomView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TQNoPurchaseViewController
static NSString *const IntroductCell = @"IntroductCell";
#pragma mark - 点击监听
//VIP点击
//跳转购买页


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupHeaderView];
}

-(void)initUI
{
    [self setTitleText:@"我的私人定制"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addPurchase];
}

-(void)setupHeaderView {
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQIntroductCell class]) bundle:nil] forCellReuseIdentifier:IntroductCell];
}
-(void)addPurchase {
//    TQPurchaseView *purchaseView = [TQPurchaseView purchaseView];
//    purchaseView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, 44);
//    _purchaseView = purchaseView;
//    [self.tableView addSubview:purchaseView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TQIntroductCell *cell = [tableView dequeueReusableCellWithIdentifier:IntroductCell];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tes"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tes"];
    }
    return cell;
//    return nil;
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

@end
