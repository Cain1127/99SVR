//
//  TQDetailedTableViewController.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 专家观点详情>**********************************/

#import "ideaDetailTableViewCell.h"
#import "TQDetailedTableViewController.h"
#import "MJExtension.h"
#import "TQcontentView.h"
#import "Masonry.h"
#import "TQSuspension.h"
#import "TQDetailedTableView.h"



@interface TQDetailedTableViewController () 
/** 悬浮框 */
@property (nonatomic ,weak)TQSuspension *Suspension;
/** tableView */
@property (nonatomic ,weak)TQDetailedTableView *tableView;
@end

@implementation TQDetailedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化的设置
    [self initSubViews];
    
}
//初始化的设置
-(void)initSubViews {
    TQDetailedTableView *tableView = [[TQDetailedTableView alloc] initWithFrame:self.view.bounds];
    self.title = @"观点详情页";
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:0 target:self action:@selector(share)];

    //设置献花和评论悬浮按钮
    [self setUpSuspensionBtn];
}

-(void)viewWillLayoutSubviews {
    //设置tableview的尺寸
}
//悬浮液按钮
-(void)setUpSuspensionBtn {
    
    TQSuspension *Suspension = [TQSuspension SuspensionForXib];
    [self.view addSubview:Suspension];
    Suspension.frame = CGRectMake(kScreenWidth - 60, (kScreenHeight - 110 - 64), 50, 100);
    [self.view bringSubviewToFront:Suspension];
    self.Suspension = Suspension;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}


#pragma mark - Table view data source
-(void)share {
    
    
}



-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.Suspension.frame = CGRectMake(<#CGFloat x#>, CGFloat y, <#CGFloat width#>, <#CGFloat height#>)
    DLog(@"%@",NSStringFromCGRect(self.Suspension.frame));

}







@end
