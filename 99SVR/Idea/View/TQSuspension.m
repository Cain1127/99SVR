//
//  TQSuspension.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQSuspension.h"
#import "TQSuspensionBtn.h"
@interface TQSuspension ()


@end
@implementation TQSuspension

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        TQSuspensionBtn *floweBtn = [[TQSuspensionBtn alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.4999)];
        [floweBtn setTitle:@"献花" forState:UIControlStateNormal];
        [floweBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
        [floweBtn setImage:[UIImage imageNamed:@"video_present_icon"] forState:UIControlStateNormal];
        [self addSubview:floweBtn];
        [floweBtn addTarget:self action:@selector(giftsTO:) forControlEvents:UIControlEventTouchUpInside];
        
        TQSuspensionBtn *commentBtn = [[TQSuspensionBtn alloc] initWithFrame:CGRectMake(0, floweBtn.height, self.width, self.height * 0.4999)];
        [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"video_present_icon"] forState:UIControlStateNormal];
        [self addSubview:commentBtn];
        [commentBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)giftsTO:(TQSuspensionBtn *)btn {
    
}

-(void)sendComment:(TQSuspensionBtn *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TQ_ideadatail_sendcomment" object:nil];

}


@end
