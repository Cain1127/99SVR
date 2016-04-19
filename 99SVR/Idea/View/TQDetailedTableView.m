//
//  TQDetailedTableView.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQDetailedTableView.h"
#import "ideaDetailTableViewCell.h"
#import "DetaileHeaderView.h"
#import "TQDetailedTableViewController.h"
#import "MJExtension.h"
#import "TQcontentView.h"
#import "Masonry.h"
#import "ComposeTextView.h"


@interface TQDetailedTableView () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
/** 输入框 */
@property (nonatomic ,weak)TQcontentView *contentView;
/** 头部试图 */
@property (nonatomic ,weak)DetaileHeaderView *headerView;

@end

@implementation TQDetailedTableView
static NSString *const detaileCell = @"detaileCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ideaDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:detaileCell];
        
        DetaileHeaderView *headerView = [DetaileHeaderView DetaileHeaderViewForXib];
        self.headerView = headerView;
        self.tableHeaderView.height = headerView.frame.size.height;
        [self setTableHeaderView:headerView];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ideaDetailTableViewCell *cell = [self dequeueReusableCellWithIdentifier:detaileCell];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


#pragma mark - Table view delegate
/**
 *  选中行后，弹出输入框和键盘.进行互动,
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self setUpInputBox];
    
    
}
-(void)setUpInputBox{
    TQcontentView *contentView = [[TQcontentView alloc] init];
    [self addSubview:contentView];
    self.contentView = contentView;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(44);
        make.height.offset(44);
    }];
    contentView.textView.delegate = self;
    
    [contentView.textView becomeFirstResponder];
}



//监听键盘状态,动画弹出对话框
-(void)keyboardWillChange:(NSNotification *)notice {
    
    NSDictionary *userInfo = [notice userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offsetY = kScreenHeight - keyboardRect.origin.y;
    DLog(@"%@",NSStringFromCGRect(keyboardRect));
    
    //更新约束
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-offsetY);
        DLog(@"%@",NSStringFromCGRect(self.contentView.frame));
        
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.contentView.hidden = YES;
}


@end
