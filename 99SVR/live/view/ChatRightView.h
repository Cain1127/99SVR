//
//  ChatRightView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatRightDelegate <NSObject>

- (void)clickRoom:(UIButton *)button index:(NSInteger)nIndex;

@end

@interface ChatRightView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) id<ChatRightDelegate> delegate;

@end
