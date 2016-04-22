//
//  TraderTableViewModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TraderTableViewModel.h"
#import "TraderHomeCell.h"
#import "StockMacro.h"
#import "StockDealViewController.h"

@interface TraderTableViewModel ()
/**仓库记录的数据*/
@property (nonatomic , copy) NSArray *tabDataArray;
@property (nonatomic , assign) NSInteger tableTag;
@property (nonatomic , strong) UIViewController *viewController;
@end

@implementation TraderTableViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        
        self.tabDataArray = @[];
        self.viewController = viewController;
    }
    return self;
}


-(void)setTabDelegateAndTabDataSoure:(UITableView *)tab{
    tab.delegate = self;
    tab.dataSource = self;
}

#pragma mark tableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tabDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ValueWithTheIPhoneModelString(@"100,120,140,160");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    
    TraderHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TraderHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewController.navigationController pushViewController:[[StockDealViewController alloc]init] animated:YES];
    
}

-(void)setDataArray:(NSArray *)dataArray{
    
    self.tabDataArray = dataArray;
}

@end
