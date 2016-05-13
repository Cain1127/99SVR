//
//  SocketNetworkView.h
//  99SVR
//
//  Created by jiangys on 16/5/13.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SocketNetworkViewState) {
    SocketNetworkViewStateNormal, // 正常
    SocketNetworkViewStateNoNetwork, // 没网
    SocketNetworkViewStateReconnect //　重连
};

@interface SocketNetworkView : UIView
@property(nonatomic, assign) SocketNetworkViewState socketNetworkViewState;
@end
