//
//  ConsumeRankCell.h
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumeRankCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgHead;
@property (nonatomic,strong) UIImageView *imgRank;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblGoid;
@property (nonatomic,strong) UILabel *lblBad;

- (void)setRankInfo:(NSInteger)nIndex;

@end
