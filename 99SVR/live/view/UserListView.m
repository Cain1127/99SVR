//
//  UserListView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "UserListView.h"
#import "RoomUserCell.h"

@interface UserListView()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) UIView *hiddenView;
@property (nonatomic,copy) NSArray *aryUser;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UserListView

- (id)initWithFrame:(CGRect)frame array:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        _aryUser = items;
    }
    return self;
}

- (void)setGestureHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:Rect(0, kScreenHeight, kScreenWidth, 0)];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)initView
{

    _hiddenView = [[UIView alloc] initWithFrame:Rect(0, -kRoom_head_view_height, kScreenWidth, kScreenHeight)];
    [self addSubview:_hiddenView];
    [_hiddenView setUserInteractionEnabled:YES];
    [_hiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    [_hiddenView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, kVideoImageHeight+kRoom_head_view_height, kScreenWidth, self.height-kVideoImageHeight-kRoom_head_view_height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    _tableView.tag = 4;
    
    _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(0,0);
    _tableView.layer.shadowOpacity = 1;
    _tableView.layer.shadowRadius = 4;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"RoomUserTableViewIdentifier";
    RoomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil)
    {
        cell = [[RoomUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:UIColorFromRGB(0x629aff)];
    [cell setSelectedBackgroundView:selectView];
    if(_aryUser.count>indexPath.row)
    {
        RoomUser *user = [_aryUser objectAtIndex:indexPath.row];
        [cell setRoomUser:user];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(selectUser:)]) {
        [_delegate selectUser:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)reloadItems:(NSArray *)items
{
    _aryUser = items;
    __weak UITableView *__tableView = _tableView;
    dispatch_main_async_safe(^{
        [__tableView reloadData];
    });
}



@end
