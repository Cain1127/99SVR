//
//  ZLPrivateDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLPrivateDataSource.h"
#import "CustomizedTableViewCell.h"
#import "XPrivateService.h"
#import "CustomizedModel.h"

@implementation ZLPrivateDataSource



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_aryVIP.count>_selectIndex-1)
    {
        XPrivateService *service = _aryVIP[_selectIndex-1];
        return service.summaryList.count;
    }
    return 0;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomizedTableViewCell *cell = [CustomizedTableViewCell cellWithTableView:tableView];
    if (_aryVIP.count>_selectIndex) {
        XPrivateService *service = _aryVIP[_selectIndex-1];
        if (service.summaryList.count>indexPath.row) {
            XPrivateSummary *summary = service.summaryList[indexPath.row];
            CustomizedModel *customizedModel = [[CustomizedModel alloc] init];
            customizedModel.title = summary.title;
            customizedModel.summary = summary.summary;
            customizedModel.publishTime = summary.publishtime;
            customizedModel.isOpen = service.isOpen;
            cell.customizedModel = customizedModel;
        }
    }
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 - 0.5,kScreenWidth, 0.5)];
    lineBottomView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [cell addSubview:lineBottomView];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSectionView.backgroundColor = [UIColor whiteColor];
    // 图标
    UIImageView *_selectIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
    NSString *imgSrc = [NSString stringWithFormat:@"customized_vip%zi_icon",_selectIndex];
    _selectIconImageView.image = [UIImage imageNamed:imgSrc];
    [headerSectionView addSubview:_selectIconImageView];
    
    // 标题
    UILabel *_selectVipLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectIconImageView.frame)+8, 0, 150, 40)];
    _selectVipLable.textColor = UIColorFromRGB(0x919191);
    NSString *strName = [NSString stringWithFormat:@"VIP%zi的服务内容",_selectIndex];
    _selectVipLable.text = strName;
    _selectVipLable.font = [UIFont boldSystemFontOfSize:15];
    [headerSectionView addSubview:_selectVipLable];
    
    // 疑问
    UIButton *questionButton= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 0, 40, 40)];
    [questionButton setImage:[UIImage imageNamed:@"pwd_play_h"] forState:UIControlStateNormal];
    [questionButton addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [headerSectionView addSubview:questionButton];
    
    // 添加底部线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 0.5, kScreenWidth , 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [headerSectionView addSubview:lineView];
    
    if (_aryVIP.count) {
        return headerSectionView;
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate 代理方法
// 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

// 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_aryVIP.count>_selectIndex-1)
    {
        XPrivateService *service = _aryVIP[_selectIndex-1];
        if (service.summaryList.count>indexPath.row && service.isOpen)
        {
            [self showPrivateDetail:service.summaryList[indexPath.row]];
        }
    }
}

- (void)questionClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(showWhatIsPrivate)]) {
        [_delegate showWhatIsPrivate];
    }
}

- (void)showPrivateDetail:(XPrivateSummary *)summary
{
    if (_delegate && [_delegate respondsToSelector:@selector(showPrivateDetail:)])
    {
        [_delegate showPrivateDetail:summary];
    }
}


@end
