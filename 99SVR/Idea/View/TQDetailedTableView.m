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
/** 头部试图 */
@property (nonatomic ,weak) DetaileHeaderView *headerView;
/** 聊天框 */
@property (nonatomic ,weak)TQcontentView *contentView;
@end

@implementation TQDetailedTableView

static NSString *const detaileCell = @"detaileCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化设置
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ideaDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:detaileCell];
        //添加手势监听,退出键盘
        @WeakObj(self)
        [self clickWithBlock:^(UIGestureRecognizer *gesture) {
            [selfWeak.contentView.textView resignFirstResponder];
        }];
        
        //创建子控件
        [self creatChildView];

    }
    return self;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.contentView.textView resignFirstResponder];
}

//创建子控件
-(void)creatChildView {
    
    DetaileHeaderView *headerView = [DetaileHeaderView DetaileHeaderViewForXib];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
    self.tableHeaderView = headerView;

    
    TQcontentView *contentView = [[TQcontentView alloc] initWithFrame:CGRectMake(2, self.height, kScreenWidth - 4, 100)];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:contentView];
    contentView.hidden = YES;
    self.contentView = contentView;
    
    //监听评论按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyboard) name:@"TQ_ideadatail_sendcomment" object:nil];
    //键盘即将退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)popKeyboard {
    self.scrollEnabled = YES;
    
    if (self.contentView.hidden) {
        
        [self.contentView.textView becomeFirstResponder];
    }
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
    
}


//监听键盘状态,动画弹出对话框
-(void)keyboardWillChange:(NSNotification *)notice {
    
    NSDictionary *userInfo = [notice userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offsetY = kScreenHeight - keyboardRect.origin.y;
    DLog(@"%@",NSStringFromCGRect(keyboardRect));
    
    self.contentView.hidden = NO;
    CGRect frame = self.contentView.frame;
    frame.origin.y = offsetY;
    self.contentView.frame = frame;

    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self setNeedsLayout];
    }];

}
//收起聊天框的动画
-(void)packUpComment {
    
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.height;
        self.contentView.frame = frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self setNeedsLayout];
    }completion:^(BOOL finished) {
        self.contentView.hidden = YES;
    }];
}
//滚动退出键盘
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if (!self.contentView.hidden) {
//        [self.contentView.textView resignFirstResponder];
//    }
//
//}
//键盘即将退出执行
- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.contentView.hidden) {
        return;
    }
    [self packUpComment];
}



-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
