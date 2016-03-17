//
//  ChatView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/17/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomUser;

@protocol ChatViewDelegate <NSObject>

- (void)sendMessage:(UITextView *)textView userid:(int)nUser;

@end


@interface ChatView : UIView

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,assign) id<ChatViewDelegate> delegate;
@property (nonatomic,strong) UILabel *lblInfo;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,strong) UILabel *lblPlace;
@property (nonatomic,copy) NSString *strName;


- (void)setChatInfo:(RoomUser *)user;

@end
