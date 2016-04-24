//
//  EsotericaCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>


@class TextEsoterModel;

@class EsotericaCell;
@protocol EsoterDelegate <NSObject>

- (void)clickEsoter:(EsotericaCell*)cell model:(TextEsoterModel *)model;

@end

@interface EsotericaCell : UITableViewCell

@property (nonatomic,strong) TextEsoterModel *textModel;

@property (nonatomic,assign) id<EsoterDelegate> delegate;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnOper;
@property (nonatomic,strong) UIButton *btnPrice;
@property (nonatomic,strong) UILabel *lblInfo;
@property (nonatomic) NSInteger nRow;
@property (nonatomic) UIEdgeInsets insets;

@end
