//
//  MyPrivateView.h
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

//typedef void(^CloseHandle)(void);

@interface ZLWhatIsPrivateView : UIView
/**类型 0是 需要显示关闭按钮。1不需要 给高手操盘详情页面的什么是私人定制跳转页面使用*/
- (id)initWithFrame:(CGRect)frame withViewTag:(NSInteger)tag;
@property (nonatomic,strong) DTAttributedTextView *textView;

- (void)setContent:(NSString *)strInfo;


@end
