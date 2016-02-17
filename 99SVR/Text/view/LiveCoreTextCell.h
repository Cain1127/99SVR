//
//  LiveCoreTextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 1/10/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@class ThumButton;
@interface LiveCoreTextCell : UITableViewCell

@property (nonatomic,strong) DTAttributedTextContentView *textCoreView;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) ThumButton *btnThum;
@property (nonatomic,strong) UILabel *line;

@end
