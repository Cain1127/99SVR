//
//  TextNewCell.h
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@class IdeaDetails;

@interface TextNewCell : UITableViewCell


@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) UIButton *btnObserved;
@property (nonatomic,strong) UIButton *btnMsg;
@property (nonatomic,strong) UIButton *btnThum;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UILabel *lblTitle;

- (void)setDetails:(IdeaDetails *)idea;


@end
