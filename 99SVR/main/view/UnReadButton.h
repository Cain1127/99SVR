//
//  UnReadButton.h
//  99SVR
//
//  Created by xia zhonglin  on 5/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnReadButton : UIButton

@property (nonatomic,strong) UILabel *readNumber;

- (void)showNumber:(int)nNum;

@end
