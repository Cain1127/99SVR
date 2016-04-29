//
//  XIdeaDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XIdeaDataSource.h"
#import "TQIdeaModel.h"
#import "TQDetailedTableViewController.h"
#import "TQIdeaTableViewCell.h"
@interface XIdeaDataSource()
{
    NSCache *viewCache;
}

@end

@implementation XIdeaDataSource

- (void)setAryModel:(NSArray *)aryModel
{
    _aryModel = aryModel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *viewPointCellName = @"TQIdeaTableViewIdentifier";
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    if (!viewCache)
    {
        viewCache = [[NSCache alloc] init];
        [viewCache setTotalCostLimit:10];
    }
    TQIdeaTableViewCell *cell = [viewCache objectForKey:strKey];
    if (!cell) {
        cell = [[TQIdeaTableViewCell alloc] initWithReuseIdentifier:viewPointCellName];
        [viewCache setObject:cell forKey:viewCache];
    }
    if (_aryModel.count>indexPath.row) {
        [cell setIdeaModel:[_aryModel objectAtIndex:indexPath.section]];
    }
    return cell;
}
#pragma mark - TableViewDelegete
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_aryModel.count>indexPath.row) {
        TQIdeaModel *model = _aryModel[indexPath.section];
        if (_delegate && [_delegate respondsToSelector:@selector(selectIdea:)]) {
            [_delegate selectIdea:model];
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
