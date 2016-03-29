//
//  EsotericaCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextEsoterModel;

@interface EsotericaCell : UITableViewCell

@property (nonatomic,strong) TextEsoterModel *textModel;

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnOper;
@property (nonatomic,strong) UIButton *btnPrice;

@end
