//
//  ConsumeRankDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ConsumeRankDataSource.h"
#import "ConsumeRankCell.h"
#import "XConsumeRankModel.h"
#import "UIImageView+WebCache.h"
#import "RoomChatNull.h"

@implementation ConsumeRankDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_aryModel.count == 0) {
        return 1;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryModel.count==0)
    {
        return kScreenHeight-kRoom_head_view_height-kVideoImageHeight-44;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_aryModel.count==0)
    {
        RoomChatNull *cell = [tableView dequeueReusableCellWithIdentifier:@"nullInfoCell"];
        if (!cell)
        {
            cell = [[RoomChatNull alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nullInfoCell"];
        }
        cell.lblInfo.text = @"没有贡献榜";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *strConsumeRank = @"ConsumeRankIdentifier";
    ConsumeRankCell *cell = [tableView dequeueReusableCellWithIdentifier:strConsumeRank];
    if (!cell)
    {
        cell = [[ConsumeRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strConsumeRank];
    }
    if (_aryModel.count>indexPath.section)
    {
        [self setModel:indexPath.section cell:cell];
    }
    return cell;
}

- (void)setModel:(NSInteger)nRow cell:(ConsumeRankCell *)cell
{
    [cell setRankInfo:nRow];
    if (nRow<3)
    {
        NSString *strName = [NSString stringWithFormat:@"video_list_%zi_icon",nRow+1];
        [cell.imgRank setImage:[UIImage imageNamed:strName]];
    }
    XConsumeRankModel *model = _aryModel[nRow];
    [cell.lblBad setText:NSStringFromInteger(nRow+1)];
    char cBuffer[100]={0};
    sprintf(cBuffer,"%d_1",model.headid);
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [cell.imgHead sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"100_1"]];
    [cell.lblName setText:model.username];
    NSString *strConsume = [NSString stringWithFormat:@"%.0f玖玖币",ceilf([model.consume floatValue])];
    [cell.lblGoid setText:strConsume];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
