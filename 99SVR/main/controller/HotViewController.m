//
//  HotViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "HotViewController.h"
#import "RoomGroup.h"
#import "RoomHttp.h"

@interface HotViewController()
{
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *aryObj;

@end

@implementation HotViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}

@end
