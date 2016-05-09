//
//  HistorySearchDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HistorySearchDataSource.h"
#import "XHistoryCell.h"

@interface HistorySearchDataSource()<DelHistDelegate>

@property (nonatomic,copy) NSArray *aryModel;

@end

@implementation HistorySearchDataSource

- (void)setModel:(NSArray *)aryModel
{
    _aryModel = aryModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HistoryViewIdentifier = @"historyViewIdentifier";
    XHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryViewIdentifier];
    if (cell==nil) {
        cell = [[XHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HistoryViewIdentifier];
    }
    if(_aryModel.count>indexPath.row)
    {
        cell.lblText.text = [_aryModel objectAtIndex:indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_aryModel.count>indexPath.row) {
        NSString *strInfo = [_aryModel objectAtIndex:indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(selectIndex:)]) {
            [_delegate selectIndex:strInfo];
        }
    }
}

- (void)delText:(NSString *)strText{
    DLog(@"delText:%@",strText);
    if (_delegate && [_delegate respondsToSelector:@selector(delSelectIndex:)]) {
        [_delegate delSelectIndex:strText];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(_aryModel.count>0)
//    {
//        UIView *clearView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
//        UIButton *btnClear = [UIButton buttonWithType: UIButtonTypeCustom];
//        [clearView addSubview:btnClear];
//        [btnClear setTitle:@"清楚历史记录" forState:UIControlStateNormal];
//        [btnClear setTitleColor:COLOR_Btn_Select forState:UIControlStateNormal];
//        btnClear.frame = Rect(0, 0, kScreenWidth, 44);
//        [btnClear addTarget:self action:@selector(addClearAll) forControlEvents:UIControlEventTouchUpInside];
//        return clearView;
//    }
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(_aryModel.count>0)
//    {
//        return 44;
//    }
//    return 0.1;
//}

- (void)addClearAll
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAll)]) {
        [_delegate deleteAll];
    }
}

// 滑动关闭键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
