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

@implementation ConsumeRankDataSource

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strConsumeRank = @"ConsumeRankIdentifier";
    ConsumeRankCell *cell = [tableView dequeueReusableCellWithIdentifier:strConsumeRank];
    if (!cell) {
        cell = [[ConsumeRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strConsumeRank];
    }
    if (_aryModel.count>indexPath.section) {
        [self setModel:indexPath.section cell:cell];
    }
    return cell;
}

- (void)setModel:(NSInteger)nRow cell:(ConsumeRankCell *)cell{
    [cell setRankInfo:nRow];
    if (nRow<3) {
        NSString *strName = [NSString stringWithFormat:@"video_list_%zi_icon",nRow+1];
        [cell.imgRank setImage:[UIImage imageNamed:strName]];
    }
    XConsumeRankModel *model = _aryModel[nRow];
    [cell.lblBad setText:NSStringFromInteger(nRow)];
    char cBuffer[100]={0};
    sprintf(cBuffer,"%d_1",model.headid);
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [cell.imgHead sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultHead_1"]];
    [cell.lblName setText:model.username];
    NSString *strConsume = [NSString stringWithFormat:@"%.01f",[model.consume floatValue]];
    [cell.lblGoid setText:strConsume];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end