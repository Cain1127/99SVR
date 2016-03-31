//
//  SexViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SexViewController



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *strIden
//    UITableViewCell *tableView = [tableView dequeueReusableCellWithIdentifier:@""];
    return nil;
}

@end
