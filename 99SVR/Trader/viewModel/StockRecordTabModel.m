//
//  StockRecordTabModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordTabModel.h"
#import "MacroHeader.h"
#import "StockRecordCell.h"
@interface StockRecordTabModel ()
/**交易记录*/
@property (nonatomic , strong) UITableView *busTab;
/**持仓情况*/
@property (nonatomic , strong) UITableView *houseTab;
@property (nonatomic , strong) UIViewController *viewController;

@end

@implementation StockRecordTabModel

- (instancetype)initWithViewController:(UIViewController *)viewController withDayTabViews:(NSArray *)tableViews
{
    self = [super init];
    if (self) {
        self.busTab = tableViews[0];
        self.houseTab = tableViews[1];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    
    StockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[StockRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = @"sss";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.viewController.navigationController pushViewController:[[StockDealViewController alloc]init] animated:YES];
    
}

@end
