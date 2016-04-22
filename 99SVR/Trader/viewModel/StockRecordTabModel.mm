//
//  StockRecordTabModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordTabModel.h"
#import "StockMacro.h"
#import "StockRecordCell.h"
@interface StockRecordTabModel ()

/**仓库记录的数据*/
@property (nonatomic , strong) NSArray *tabDataArray;

@property (nonatomic , assign) NSInteger tableTag;
@end

@implementation StockRecordTabModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.tabDataArray = @[];
    }
    return self;
}


#pragma mark tableView delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabDataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return STORCK_RecordCell_H + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    StockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[StockRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (self.tabDataArray.count==0) {
        return nil;
    }
    StockDealModel *model = self.tabDataArray[indexPath.row];
    [cell setCellDataWithModel:model withTag:self.tableTag];
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)setDataArray:(NSArray *)dataArray WithRecordTableTag:(NSInteger)tag{
    self.tabDataArray = dataArray;
    self.tableTag = tag;
}


@end
