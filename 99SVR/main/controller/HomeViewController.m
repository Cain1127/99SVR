//
//  HomeViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/7/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HomeViewController.h"
#import "ZLTabBar.h"
#import "IndexViewController.h"


@interface HomeViewController ()
{
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setTitleText:@"首页"];
    [self initUIHead];
}

- (void)initUIHead
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"switcher"] forState:UIControlStateNormal];
    [leftBtn clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SHOW_LEFT_VC object:nil];
     }];
    [self setLeftBtn:leftBtn];
}

- (void)initUIBody
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
