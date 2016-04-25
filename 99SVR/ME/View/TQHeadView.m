//
//  HeadView.m
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import "TQHeadView.h"

@implementation TQHeadView

+(instancetype)headView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TQHeadView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    
    self.IconImageView.layer.cornerRadius = 40;
    self.IconImageView.layer.masksToBounds = YES;
}

@end
