//
//  IdeaViewController.m
//  99SVR
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "IdeaViewController.h"
#import "TQideaTableViewCell.h"
#import "GroupListRequest.h"
#import "MJRefresh.h"
#import "SearchController.h"

#import "IdeaDetailedTableViewController.h"

@interface IdeaViewController () <UITableViewDelegate, UITableViewDataSource>
/** 列表 */
@property (nonatomic ,weak)UITableView *ideaTableView;
@end

@implementation IdeaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"信箱" style:0 target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:0 target:self action:@selector(searchClick)];
    UITableView *tableView = [[UITableView alloc] init];
//    tableView.backgroundColor = [UIColor redColor];
    tableView.frame = self.view.frame;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    tableView.rowHeight = 200;
    self.ideaTableView = tableView;
    
//    [self.ideaTableView registerNib:[[NSBundle mainBundle] pathForResource:@"TQIdeaTableViewCell" ofType:nil] forCellReuseIdentifier:ideaCell];
    
}

- (void)showLeftView
{
    [self leftItemClick];
}
- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ideaCell = @"status";

    TQideaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideaCell];

    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TQideaTableViewCell" bundle:nil] forCellReuseIdentifier:ideaCell];
        cell = [tableView dequeueReusableCellWithIdentifier:ideaCell];
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IdeaDetailedTableViewController *detaileVc = [[IdeaDetailedTableViewController alloc] init];
//    [self presentViewController:detaileVc animated:YES completion:nil];
    [self.navigationController pushViewController:detaileVc animated:YES];
    
}

@end
