//
//  TQSectionsHeaderView.m
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQSectionsHeaderView.h"

@implementation TQSectionsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *Vipbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Vipbtn.frame = CGRectMake(4, 4, 36, 36);
        Vipbtn.hidden = YES;
        [self addSubview:Vipbtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Vipbtn.width + 44, 4, 100, 36)];
        [self addSubview:titleLabel];
        
        
        UIButton *whyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        whyBtn.frame = CGRectMake(40, 4, 36, 36);
        whyBtn.hidden = YES;
        [self addSubview:whyBtn];  

    }
    return self;
}
@end
