//
//  SocketNetworkView.m
//  99SVR
//
//  Created by jiangys on 16/5/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//  网络重连

#import "SocketNetworkView.h"

@interface SocketNetworkView()
@property (nonatomic, strong) UIButton *notNetworkButton;
@property (nonatomic, strong) UIView *reconnectView;
@end

@implementation SocketNetworkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect){0,64,kScreenWidth,44};
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    contentView.backgroundColor = COLOR_Auxiliary_Yellow;
    [self addSubview:contentView];
    
    _notNetworkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _notNetworkButton.frame = contentView.frame;
    [_notNetworkButton setImage:[UIImage imageNamed:@"home_network_loading_icon"] forState:UIControlStateNormal];
    [_notNetworkButton setImage:[UIImage imageNamed:@"home_network_loading_icon"] forState:UIControlStateHighlighted];
    [_notNetworkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_notNetworkButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_notNetworkButton.titleLabel setFont:Font_15];
    [_notNetworkButton setTitle:@"网络连接异常，请点击重连" forState:UIControlStateNormal];
    [_notNetworkButton setTitleColor:COLOR_Text_343434 forState:UIControlStateNormal];
    [_notNetworkButton addTarget:self action:@selector(notNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_notNetworkButton];
    
    _reconnectView = [[UIView alloc] init];
    _reconnectView.frame = contentView.frame;
    [contentView addSubview:_reconnectView];
    
    NSString *strReconnect = @"正在重连...";
    CGSize strReconnectSize = [strReconnect sizeMakeWithFont:Font_15];
    
    UIImageView *iconImageView = [self iconImageViewWithFrame:CGRectMake(kScreenWidth*0.5 - strReconnectSize.width * 0.5 - 10, 0, 20, contentView.height)];
    [_reconnectView addSubview:iconImageView];
    
    UILabel *reconnectLabel = [[UILabel alloc] init];
    reconnectLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame)+5, 0, strReconnectSize.width, contentView.height);
    reconnectLabel.text = strReconnect;
    reconnectLabel.textColor = COLOR_Text_343434;
    reconnectLabel.font = Font_15;
    [_reconnectView addSubview:reconnectLabel];
    
    _reconnectView.hidden = YES;
}

- (UIImageView *)iconImageViewWithFrame:(CGRect)frame{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    NSMutableArray *images = [NSMutableArray array];
    for (int i=1; i<12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_cup_45_30_00%02d",i]];
        [images addObject:image];
    }
    imgView.animationImages = images;
    imgView.animationDuration= 1;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView startAnimating];
    return imgView;
}

- (void)setSocketNetworkViewState:(SocketNetworkViewState)socketNetworkViewState
{
    if (socketNetworkViewState == SocketNetworkViewStateNormal) {
        _notNetworkButton.hidden = NO;
        _reconnectView.hidden = YES;
    }
    else if (socketNetworkViewState == SocketNetworkViewStateNoNetwork) {   // 没网状态
        _notNetworkButton.hidden = NO;
        _reconnectView.hidden = YES;
    } else { // 重连状态
        _notNetworkButton.hidden = YES;
        _reconnectView.hidden = NO;
    }
}

- (void)notNetworkClick
{
    DLog(@"notNetworkClick");
    _notNetworkButton.hidden = YES;
    _reconnectView.hidden = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
        [sing reConnect]; // 重连操作
    });
}

@end
