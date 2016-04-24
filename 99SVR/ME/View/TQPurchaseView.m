//
//  TQPurchaseView.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQPurchaseView.h"

@implementation TQPurchaseView

- (IBAction)purchaseClick:(id)sender {
    
}

+(instancetype)purchaseView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

@end
