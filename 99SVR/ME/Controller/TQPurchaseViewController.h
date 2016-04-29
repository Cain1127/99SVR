//
//  DemoViewController.h
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

/**购买vip或者升级vip成功*/
typedef void(^BuyVipSucessHandle)(void);

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "StockDealModel.h"
@interface TQPurchaseViewController : CustomViewController
@property (nonatomic , strong) StockDealModel *stockModel;
@property (nonatomic , copy) BuyVipSucessHandle handle;

@end
