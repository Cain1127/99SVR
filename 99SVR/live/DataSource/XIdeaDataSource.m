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
    TQIdeaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:viewPointCellName];
    if (!cell)
    {
        cell = [[TQIdeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewPointCellName];
    }
    if (_aryModel.count>indexPath.row)
    {
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


// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL value = YES;
    
    NSLog(@"%f",scrollView.contentOffset.y);
    
    NSLog(@"contentSize.height%f",scrollView.contentSize.height);
    NSLog(@"size.height%f",scrollView.frame.size.height);
    
    if (scrollView.contentOffset.y<=149/2.0) {//判断是不是要显示新观点的提示//当前cell的高度一半
        value = NO;//不显示
    }else{
        value = YES;//显示
    }
    
//    if ((scrollView.contentSize.height>=scrollView.frame.size.height)&&(value==NO)) {
//        value = YES;
//    }
    
    BOOL topValue = NO;

    if (scrollView.contentOffset.y<=0) {
        
        topValue = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(ideaPromptViewIsShowBool:tabToTopValue:)]) {
        [self.delegate ideaPromptViewIsShowBool:value tabToTopValue:topValue];
    }

}

@end
