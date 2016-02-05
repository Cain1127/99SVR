//
//  ZLCoreTextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTAttributedLabel;
@class DTAttributedTextContentView;
@class DTAttributedTextView;

@interface ZLCoreTextCell : UITableViewCell

@property (nonatomic, strong) DTAttributedTextView *lblInfo;
//@property (nonatomic,strong) UILabel *lblInfo;

@end
