//
//  TQMessageCell.h
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQMessageModel;
@class TQMessageCell;
@protocol TQMessageDelegate <NSObject>


- (void)clickCell:(TQMessageCell *)cell show:(BOOL)bAll;

@end

@interface TQMessageCell : UITableViewCell

@property (nonatomic ,strong) TQMessageModel *messageModel;
@property (nonatomic) BOOL bShow;
@property (nonatomic) NSInteger section;


@property (nonnull,assign) id<TQMessageDelegate> delegate;
- (CGFloat)requiredRowHeightInTableView;
- (IBAction)showInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@end
