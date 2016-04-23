//
//  TQMeCustomizedViewController.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//已经购买的私人定制界面

#import "TQMeCustomizedViewController.h"
#import "TQMecustomView.h"
#import "TQNoCustomView.h"
#import "TQNoPurchaseViewController.h"
#import "TQMailboxViewController.h"
#import "UIBarButtonItem+Item.h"

@interface TQMeCustomizedViewController ()

@end

@implementation TQMeCustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//        TQMecustomView *MeView = [[TQMecustomView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:MeView];
    
        TQNoCustomView *NOView = [[TQNoCustomView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:NOView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushIntroductController) name:MESSAGE_TQINTORDUCT_VC object:nil];
    
    [self initUi];
}
-(void)initUi{
    self.title = @"私人定制";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(BackClick) title:@"信箱"];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
//准备删除
-(void)BackClick {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"TQMailboxViewController" bundle: nil];
    TQMailboxViewController *mailbox = [board instantiateViewControllerWithIdentifier: @"MailboxViewController"];
    [self.navigationController pushViewController:mailbox animated:YES];

}

-(void)pushIntroductController {
    TQNoPurchaseViewController *IntroductionVc = [[TQNoPurchaseViewController alloc] init];
    [self.navigationController pushViewController:IntroductionVc animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
