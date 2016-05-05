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
#import "StockRecordViewController.h"
#import "StockMacro.h"
#import "UIAlertView+Block.h"
#import "TQPurchaseViewController.h"
#import "StockNotVipView.h"
#import "LoginViewController.h"
@interface StockDealTableModel ()<StockNotVipViewDelegate>
{
    NSCache *_cache;
    BOOL _isVipBool;
    StockDealModel *_model;
}
@end

@implementation StockDealTableModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = @[];
        _cache = [[NSCache alloc]init];
        _isVipBool = NO;
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    
    if (indexPath.section==0) {
        
        height = STORCK_Deal_StockCell_H;
    }else if (indexPath.section ==1){
        
        height = _isVipBool? STORCK_Deal_BusinessRecordCell_VIP_H: STORCK_Deal_BusinessRecordCell_NotVIP_H;
    }else{
        
        height = _isVipBool? STORCK_Deal_WareHouseRecordCell_VIP_H: STORCK_Deal_WareHouseRecordCell_NotVIP_H;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y<0) {
        [scrollView setContentOffset:(CGPoint){0,0} animated:NO];
        scrollView.backgroundColor = COLOR_Bg_Blue;
    }else{
        scrollView.backgroundColor = COLOR_Bg_Gay;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    if (!headerView) {
        
        headerView = [[UITableViewHeaderFooterView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,0}];
        headerView.contentView.backgroundColor = COLOR_Bg_Gay;
        headerView.userInteractionEnabled = YES;
        headerView.tag = section;
        UITapGestureRecognizer *headerViewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClick:)];
        headerViewTap.numberOfTapsRequired = 1;
        [headerView addGestureRecognizer:headerViewTap];
        
        UIView *backView = [[UIView alloc]init];
        backView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
        backView.layer.borderWidth = LineView_Height;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [headerView.contentView addSubview:backView];
        
        //左边标题
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.font = Font_15;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.tag = 100;
        [backView addSubview:leftLabel];
        
        //右边标题
        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = Font_15;
        rightLab.tag = 101;
        [backView addSubview:rightLab];

        //右边的图标
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag = 102;
        imageView.image =[UIImage imageNamed:@"home_seeall_arrow"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
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
            make.width.equalTo(@18);
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
        imageView.hidden = YES;


    }else if (section==1){
    
        leftLab.text = @"交易动态";
        rightLab.text = @"全部记录";
        imageView.hidden = NO;
    }else{
        
        leftLab.text = @"持仓详情";
        rightLab.text = @"全部持仓";
        imageView.hidden = NO;
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
    cell.notVipView.delegate = self;
    [cell setCellDataWithModel:model withIsVip:_isVipBool withCellId:cellIdArray[indexPath.section] withStockHeaderModel:_model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithTableView:)]) {
        [self.delegate didSelectRowAtIndexPathWithTableView:indexPath];
    }    
}

#pragma mark 点击hederView
-(void)headerViewClick:(UIGestureRecognizer *)gap{
    
    UIView *view = gap.view;
    NSInteger tag = view.tag;
    
    if ([self.delegate respondsToSelector:@selector(didClickTableHeaderViewTag:)]) {
        [self.delegate didClickTableHeaderViewTag:tag];
    }
}

-(void)setIsShowRecal:(NSString *)showRecal withDataModel:(StockDealModel *)model{

    _model = model;
    if ([showRecal isEqualToString:@"show"]) {
        _isVipBool = YES;
    }else{
        _isVipBool = NO;
    }
}

#pragma mark StockNotVipViewDelegate
-(void)stockNotVipViewDidSelectIndex:(NSInteger)index{
    

    switch (index) {
        case 1://去购买
        {
            [self goBuyVip];
        }
            break;
        case 2://什么是私人订制
        {
            
            DLog(@"什么是私人订制");
        }
            break;

        default:
            break;
    }
    

}
/**
 *  去购买VIP
 */
#pragma mark 去购买VIP
-(void)goBuyVip{
    
    if ([self.delegate respondsToSelector:@selector(goBuyVipService)]) {
        [self.delegate goBuyVipService];
    }
}

@end
