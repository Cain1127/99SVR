//
//  TQMecustomView.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "XMecustomDataSource.h"
#import "TQMeCustomizedModel.h"
#import "XMeCustomCell.h"

@interface XMeCustomDataSource ()


@end

@implementation XMeCustomDataSource

static NSString *const MeCustomizedCell = @"MeCustomizedCell";

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMeCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:MeCustomizedCell];
    if (!cell) {
        cell = [[XMeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeCustomizedCell];
    }
    if (_aryModel.count>indexPath.section) {
        TQMeCustomizedModel *model = _aryModel[indexPath.section];
        cell.lblName.text = model.teamname;
        cell.lblLevel.text = model.levelname;
        NSString *strInfo = [NSString stringWithFormat:@"有效期:%@",model.expirationdate];
        cell.lblTime.text = strInfo;
        
        char cBuffer[100]={0};
        sprintf(cBuffer,"100_1");
        NSString *strName = [NSString stringWithUTF8String:cBuffer];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
        [cell.imgView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"default"]];
        NSString *imgName = [NSString stringWithFormat:@"customized_vip%d_icon",model.levelid];
        cell.imgLevel.image = [UIImage imageNamed:imgName];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_aryModel.count>indexPath.section && _delegate && [_delegate respondsToSelector:@selector(selectIndex:)])
    {
        TQMeCustomizedModel *model = _aryModel[indexPath.section];
        [_delegate selectIndex:model];
    }
}

@end
