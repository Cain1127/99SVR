//
//  TraderTableViewModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TraderTableViewModel.h"
#import "TraderHomeCell.h"
#import "MacroHeader.h"
#import "StockDealViewController.h"

@interface TraderTableViewModel ()
/**日*/
@property (nonatomic, strong) UITableView *dayTab;
/**月*/
@property (nonatomic, strong) UITableView *monTab;
/**总的*/
@property (nonatomic, strong) UITableView *totalTab;

@end

@implementation TraderTableViewModel

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews
{
    self = [super init];
    if (self) {
        self.dayTab = tableViews[0];
        self.monTab = tableViews[1];
        self.totalTab = tableViews[2];
        for (int i=0; i!=tableViews.count; i++) {
            [self setTabDelegateAndTabDataSoure:(UITableView *)tableViews[i]];
        }
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
    
    return 20;
    
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




@end
