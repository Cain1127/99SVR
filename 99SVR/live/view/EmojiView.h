//
//  EmojiView.h
//  99SVR
//
//  Created by xia zhonglin  on 12/21/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiViewDelegate <NSObject>

- (void)sendEmojiInfo:(NSInteger)nId;

@end

@interface EmojiView : UIView

@property (nonatomic,assign) id<EmojiViewDelegate> delegate;

@end
