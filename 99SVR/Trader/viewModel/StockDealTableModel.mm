//
//  StockDealTableModel.m
//  99SVR
//
//  Created by 刘海东 on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockDealTableModel.h"
#import "StockDealCell.h"
#import "StockDealCellLabelView.h"

@interface StockDealTableModel ()
{
    NSCache *_cache;
}
@end

@implementation StockDealTableModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = @[];
        _cache = [[NSCache alloc]init];
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    
    
    StockDealModel *model = _dataArray[indexPath.section][indexPath.row];
    BOOL vipBool = YES;
    if ([model.vipLevel integerValue]>0) {
        vipBool = YES;
    }else{
        vipBool = NO;
    }
    
    if (indexPath.section==0) {
        
        height =ScreenWidth * 0.75;
    }else if (indexPath.section ==1){
        
        height = vipBool? 50: 100;
    }else{
        
        height = vipBool? 120: 200;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = _dataArray[section];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        return 10;
    }else{
        
        return 50;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    if (!headerView) {
        
        headerView = [[UITableViewHeaderFooterView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,0}];
        headerView.contentView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        headerView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        headerView.layer.borderWidth = 1.0f;
        headerView.layer.masksToBounds = YES;
        
        UIView *backView = [[UIView alloc]init];
        backView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        backView.layer.borderWidth = 1.0f;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [headerView.contentView addSubview:backView];
        
        //左边标题
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.tag = 100;
        [backView addSubview:leftLabel];
        
        //右边标题
        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.tag = 101;
        [backView addSubview:rightLab];

        //右边的图标
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag = 102;
        [backView addSubview:imageView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.top.equalTo(@10);
            make.bottom.equalTo(@0);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(@(-10));
            make.top.equalTo(@0);
            make.width.equalTo(@20);
            make.bottom.equalTo(@0);
        }];
        
        
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imageView.mas_left).offset(-10);
            make.top.equalTo(@0);
            make.width.equalTo(@100);
            make.bottom.equalTo(@0);
        }];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(10));
            make.top.equalTo(@0);
            make.width.equalTo(@100);
            make.bottom.equalTo(@0);
        }];

    
    }
    
    
    UILabel *leftLab = [headerView.contentView viewWithTag:100];
    UILabel *rightLab = [headerView.contentView viewWithTag:101];
    UIImageView *imageView = [headerView.contentView viewWithTag:102];
    
    if (section==0) {
    
        leftLab.text = @"";
        rightLab.text = @"";
        imageView.backgroundColor = [UIColor whiteColor];


    }else if (section==1){
    
        leftLab.text = @"交易动态";
        rightLab.text = @"全部记录";
        imageView.backgroundColor = [UIColor yellowColor];
        
    }else{
        
        leftLab.text = @"持仓详情";
        rightLab.text = @"全部持仓";
        imageView.backgroundColor = [UIColor yellowColor];
    }
    return headerView;
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *cellIdArray = @[@"section0",@"section1",@"section2"];
    NSString *cellId = cellIdArray[indexPath.section];
    StockDealCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[StockDealCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    StockDealModel *model = _dataArray[indexPath.section][indexPath.row];
    BOOL vipBool = YES;
    if ([model.vipLevel integerValue]>0) {
        vipBool = YES;
    }else{
        vipBool = NO;
    }
    [cell setCellDataWithModel:model withIsVip:vipBool withCellId:cellIdArray[indexPath.section]];
    return cell;
}

@end
