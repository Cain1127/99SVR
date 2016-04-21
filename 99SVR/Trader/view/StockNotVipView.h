//
//  StockNotVipView.h
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,StockNotVipViewType){
    /**交易动态*/
    StockNotVipViewType_Business,
    /**持仓情况*/
    StockNotVipViewType_Storehouse,
};
@interface StockNotVipView : UIView

/**类型*/
@property (nonatomic , assign) StockNotVipViewType type;

/**去购买*/
@property (nonatomic , strong) UILabel *buyLab;
/**文字*/
@property (nonatomic , strong) UILabel *textLab;
/**什么是定制服务*/
@property (nonatomic , strong) UILabel *serviceLab;
@end
