//
//  PrivateVipView.h
//  99SVR_UI
//
//  Created by jiangys on 16/4/26.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrivateVipModel;

@interface PrivateVipView : UIView

@property (nonatomic, strong) NSArray *privateVipArray;
@property(nonatomic, copy) void (^ selectVipBlock)(NSUInteger vipLevelId);

@end
