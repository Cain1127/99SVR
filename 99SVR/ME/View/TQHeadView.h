//
//  HeadView.h
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQHeadView : UIView

/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
/**团队名称*/
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
/**注意*/
@property (weak, nonatomic) IBOutlet UILabel *attentionLab;

+(instancetype)headView;

@end
