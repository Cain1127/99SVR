//
//  TQPurchaseView.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQPurchaseView.h"

@implementation TQPurchaseView

<<<<<<< HEAD
+(instancetype)purchaseView
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil] [0];
}

=======
- (IBAction)purchaseClick:(id)sender {
    
}

+(instancetype)purchaseView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}
>>>>>>> 0cfd691cecefffeaf6a7bb1034f5793c3e34772b

@end
