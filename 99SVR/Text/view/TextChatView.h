//
//  TextChatView.h
//  99SVR
//
//  Created by xia zhonglin  on 3/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomUser;

@protocol TextChatViewDelegate <NSObject>

- (void)sendMessage:(UITextView *)textView userid:(int)nUser;

@end


@interface TextChatView : UIView

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,assign) id<TextChatViewDelegate> delegate;
@property (nonatomic,strong) UILabel *lblInfo;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,strong) UILabel *lblPlace;
@property (nonatomic,copy) NSString *strName;


- (void)setChatInfo:(RoomUser *)user;


@end
