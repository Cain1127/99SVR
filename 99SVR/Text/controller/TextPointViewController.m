//
//  TextPointViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 2/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextPointViewController.h"
#import "TextTcpSocket.h"

@interface TextPointViewController ()

@property (nonatomic,strong) TextTcpSocket *socket;

@end

@implementation TextPointViewController

- (id)initWithSocket:(TextTcpSocket *)socket{
    self = [super init];
    _socket = socket;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
