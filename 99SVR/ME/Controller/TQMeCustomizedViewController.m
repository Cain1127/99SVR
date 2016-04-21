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

@interface TQMeCustomizedViewController ()

@end

@implementation TQMeCustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//        TQMecustomView *MeView = [[TQMecustomView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:MeView];
    
        TQNoCustomView *NOView = [[TQNoCustomView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:NOView];

    

}




@end
