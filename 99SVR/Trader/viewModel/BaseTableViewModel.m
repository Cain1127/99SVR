//
//  BaseTableViewModel.m
//  DDChartView
//
//  Created by 刘海东 on 16/4/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaseTableViewModel.h"
@implementation BaseTableViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews;
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        _tableView = tableViews[0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

-(void)setTableViewData:(NSArray *)dataArray{
    if (dataArray.count!=0) {
        _dataArray = dataArray;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
