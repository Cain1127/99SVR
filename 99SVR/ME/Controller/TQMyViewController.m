//
//  TQMyViewController.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMyViewController.h"
#import "TQNoPurchaseViewController.h"
#import "TQMeCustomizedViewController.h"
#import "TQMailboxViewController.h"

@interface TQMyViewController ()

@end

@implementation TQMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightClick) title:@"我的私人定制"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(mailboxClick) image:@"nav_menu_icon_n" highImage:@"nav_menu_icon_p"];
    
}
-(void)mailboxClick {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"TQMailboxViewController" bundle: nil];
    TQMailboxViewController *mailbox = [board instantiateViewControllerWithIdentifier: @"MailboxViewController"];
    [self.navigationController pushViewController:mailbox animated:YES];

}

-(void)rightClick {
    
    int a = 3;
    if (a == 2) {
        TQNoPurchaseViewController *nopurVC = [[TQNoPurchaseViewController alloc] init];
        [self.navigationController pushViewController:nopurVC animated:YES];
    }else {
        TQMeCustomizedViewController *mecustVC = [[TQMeCustomizedViewController alloc] init];
        [self.navigationController pushViewController:mecustVC animated:YES];
    }
}









@end
