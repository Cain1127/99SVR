//
//  TraderTableViewModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockHomeTableViewModel.h"
#import "StockHomeCell.h"
#import "StockMacro.h"
#import "StockDealViewController.h"
#import "StockDealTableModel.h"
#import "StockDealModel.h"

@interface StockHomeTableViewModel ()
/**仓库记录的数据*/
@property (nonatomic , strong) NSArray *tabDataArray;
@property (nonatomic , assign) NSInteger tableTag;
@property (nonatomic , strong) UIViewController *viewController;
@property (nonatomic , assign) StockHomeTableViewType viewModelType;
@end

@implementation StockHomeTableViewModel

- (instancetype)initWithViewModelType:(StockHomeTableViewType)viewModelType
{
    self = [super init];
    if (self) {
        self.tabDataArray = @[];
        self.viewModelType = viewModelType;
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
    return STORCK_HOME_StockRecordCell_H;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    
    StockHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[StockHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (self.tabDataArray.count==0) {
        return nil;
    }
    StockDealModel *model = self.tabDataArray[indexPath.row];
    
    if (self.viewModelType == StockHomeTableViewType_StockHomeVC) {//首页高手操盘
        [cell setCellDataWithModel:model withTabBarInteger:2];
    }else{//房间高手操盘
        [cell setXTraderVCcellStockModel:model];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StockDealModel *model = self.tabDataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tabViewDidSelectRowAtIndexPath:withModel:)]) {
        [self.delegate tabViewDidSelectRowAtIndexPath:indexPath withModel:model];
    }
}

-(void)setDataArray:(NSArray *)dataArray{
    
    self.tabDataArray = dataArray;
}

@end
