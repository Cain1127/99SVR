//
//  TQMeCustomizedViewController.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQMeCustomizedViewController.h"
#import "TQMecustomView.h"
#import "TQNoCustomView.h"
#import "TQIntroductionViewController.h"

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

}

-(void)pushIntroductController {
    TQIntroductionViewController *IntroductionVc = [[TQIntroductionViewController alloc] init];
    [self.navigationController pushViewController:IntroductionVc animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
