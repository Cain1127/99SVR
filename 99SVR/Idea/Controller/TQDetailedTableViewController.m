//
//  TQDetailedTableViewController.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 专家观点详情>**********************************/

#import "ideaDetailTableViewCell.h"
#import "TQDetailedTableViewController.h"
#import "Masonry.h"
#import "TQSuspension.h"
#import "DetaileHeaderView.h"
#import "TQcontentView.h"
#import "ComposeTextView.h"
#import "UIBarButtonItem+Item.h"
#import "TQGifView.h"

@interface TQDetailedTableViewController () <UITableViewDataSource, UIGestureRecognizerDelegate,  UITableViewDelegate, UITextViewDelegate>
/** 悬浮框 */
@property (nonatomic ,weak)TQSuspension *Suspension;
/** tableView */
@property (nonatomic ,weak)UITableView *tableView;
/** 聊天框 */
@property (nonatomic ,weak)TQcontentView *contentView;
/** 头部试图 */
@property (nonatomic ,weak) DetaileHeaderView *headerView;

/** gift礼物弹框 */
@property (nonatomic ,weak)TQGifView *giftView;

@end

@implementation TQDetailedTableViewController
static NSString *const detaileCell = @"detaileCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化的设置
    [self initSubViews];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ideaDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:detaileCell];
}

-(void)viewWillAppear:(BOOL)animated {
    //键盘即将退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //监听评论按钮的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyboard) name:@"TQ_ideadatail_sendcomment" object:nil];
    //监听礼物控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modaGiftControllerClick) name:@"TQ_modal_Controller" object:nil];


}

-(void)modaGiftControllerClick {
   
    if (self.giftView == nil) {
    TQGifView *giftView = [[TQGifView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height * 0.4)];
        [self.view addSubview:giftView];
        self.giftView = giftView;
        self.giftView.hidden = YES;
    }else {
        self.giftView.hidden = NO;
        CGRect frame = self.giftView.frame;
        frame.origin.y = self.view.height * 0.6;
        self.giftView.frame = frame;
        [UIView animateWithDuration:0.25 animations:^{
            [self.tableView setNeedsLayout];
        }];
    }

    
    
}


//初始化的设置
-(void)initSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.title = @"观点详情页";
    tableView.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"video_room_share_icon_n"] highImage:[UIImage imageNamed:@"video_room_share_icon_p"] target:self action:@selector(share)];
    
    DetaileHeaderView *headerView = [DetaileHeaderView DetaileHeaderViewForXib];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
    self.tableView.tableHeaderView = headerView;
    
    
    TQcontentView *contentView = [[TQcontentView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, 50)];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:contentView];
    contentView.hidden = YES;
    self.contentView = contentView;
    //设置献花和评论悬浮按钮
    [self setUpSuspensionBtn];

}
//悬浮液按钮
-(void)setUpSuspensionBtn {
    
    TQSuspension *Suspension = [[TQSuspension alloc] initWithFrame:CGRectMake(kScreenWidth - 90, (kScreenHeight - 110 - 64), 80, 120)];
    [self.view addSubview:Suspension];
    [self.view bringSubviewToFront:Suspension];
    self.Suspension = Suspension;
    //添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    //2.添加手势.
    [self.tableView addGestureRecognizer:tap];

}
//实现手势方法.
- (void)tap{
    [self.contentView.textView resignFirstResponder];
}

-(void)share {
    
}

-(void)viewWillLayoutSubviews {
    //设置tableview的尺寸
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}


#pragma mark - Table view data source

-(void)popKeyboard {
    
    if (self.contentView.hidden) {
        
        [self.contentView.textView becomeFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ideaDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detaileCell];
    
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
    CGFloat offsetY = keyboardRect.origin.y;
    DLog(@"%@",NSStringFromCGRect(keyboardRect));
    
    self.contentView.hidden = NO;
    CGRect frame = self.contentView.frame;
    frame.origin.y = offsetY - self.contentView.frame.size.height;

    self.contentView.frame = frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self.tableView setNeedsLayout];
    }];
    
}
//收起聊天框的动画
-(void)packUpComment {
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.tableView.height;
    self.contentView.frame = frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self.tableView setNeedsLayout];
    }completion:^(BOOL finished) {
        self.contentView.hidden = YES;
    }];
}
//滚动退出键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.Suspension.userInteractionEnabled = NO;
    if (!self.contentView.hidden) {
        [self.contentView.textView resignFirstResponder];
        [self packUpComment];
    }

}
//键盘即将退出执行
- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.contentView.hidden) {
        return;
    }
    [self packUpComment];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.Suspension.userInteractionEnabled == NO) {
        self.Suspension.userInteractionEnabled = YES;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






@end
