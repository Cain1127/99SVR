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
@property (nonatomic ,weak) TQcontentView *contentView;
/** 头部试图 */
@property (nonatomic ,weak) DetaileHeaderView *headerView;

@end

@implementation TQDetailedTableView

static NSString *const detaileCell = @"detaileCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ideaDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:detaileCell];
        
        DetaileHeaderView *headerView = [DetaileHeaderView DetaileHeaderViewForXib];
        self.headerView = headerView;
//        CGRect frame = headerView.frame;
//        frame.size.height = 200;
//        headerView.frame = CGRectMake(0, 0, 0, 250);
        
        self.tableHeaderView = headerView;
        
        TQcontentView *contentView = [[TQcontentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [self addSubview:contentView];
        self.contentView = contentView;


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
    
    [self setUpInputBox];
    
    
}
-(void)setUpInputBox{
//    self.contentView.textView.delegate = self;
    
//    [self.contentView.textView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}



//监听键盘状态,动画弹出对话框
-(void)keyboardWillChange:(NSNotification *)notice {
    
    NSDictionary *userInfo = [notice userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offsetY = kScreenHeight - keyboardRect.origin.y;
    DLog(@"%@",NSStringFromCGRect(keyboardRect));
    
    //更新约束
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.contentView.frame;
        frame.origin.y = keyboardRect.origin.y;
        self.contentView.frame = frame;

        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.contentView.hidden = YES;
}


@end
