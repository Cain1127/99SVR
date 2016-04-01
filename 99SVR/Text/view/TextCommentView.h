//
//  TextCommentView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomUser;

@protocol TextCommentViewDelegate <NSObject>

- (void)sendMessage:(UITextView *)textView userid:(int)nUser;

@end


@interface TextCommentView : UIView

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,assign) id<TextCommentViewDelegate> delegate;
@property (nonatomic,strong) UILabel *lblInfo;
@property (nonatomic,assign) int nUserId;
@property (nonatomic,strong) UILabel *lblPlace;
@property (nonatomic,copy) NSString *strName;

- (void)setChatInfo:(RoomUser *)user;

@end