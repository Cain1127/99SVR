//
//  DemoViewController.h
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

/**购买vip或者升级vip成功*/

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "StockDealModel.h"
@interface TQPurchaseViewController : CustomViewController

//- (id)initWithTeamId:(int)nId name:(NSString *)strName;

@property (nonatomic , strong) StockDealModel *stockModel;

@end
