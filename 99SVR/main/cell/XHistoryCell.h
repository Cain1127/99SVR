//
//  XHistoryCell.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DelHistDelegate <NSObject>

- (void)delText:(NSString *)strText;

@end

@interface XHistoryCell : UITableViewCell

@property (nonatomic,assign) id<DelHistDelegate> delegate;

@property (nonatomic,strong) UILabel *lblText;
@property (nonatomic,strong) UIButton *btnDel;

@end
