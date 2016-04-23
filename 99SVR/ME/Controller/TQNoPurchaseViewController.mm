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



@interface TQNoPurchaseViewController ()
/** 头部试图 */
@property (nonatomic ,weak)TQNoCustomHeader *headerView;
/** 购买框 */
@property (nonatomic ,weak)TQPurchaseView *purchaseView;
@end

@implementation TQNoPurchaseViewController
static NSString *const IntroductCell = @"IntroductCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(20)];
    title.text = @"我的私人定制";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    [self.navigationItem setTitleView:title];
    [self setupHeaderView];
    TQPurchaseView *purchaseView = [[NSBundle mainBundle] loadNibNamed:@"purchaseView" owner:nil options:nil] [0];
    [purchaseView.purchaseBtn addTarget:self action:@selector(purchaseViewPage) forControlEvents:UIControlEventTouchUpInside];
    purchaseView.frame = CGRectMake(10, kScreenHeight - 64, kScreenWidth - 20, 44);
//    purchaseView.hidden = YES;
    _purchaseView = purchaseView;
    [self.tableView addSubview:purchaseView];
    

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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQIntroductCell class]) bundle:nil] forCellReuseIdentifier:IntroductCell];

    //头部视图
    TQNoCustomHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TQNoCustomHeader" owner:nil options:nil] lastObject];
    self.headerView = headerView;
//    headerView.frame = CGRectMake(0, 0, 0, 200);
    self.tableView.tableHeaderView = headerView;
    [headerView.questionBtn addTarget:self action:@selector(DetailsPage) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
