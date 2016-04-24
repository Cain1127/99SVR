//
//  ZLCoreTextCell.h
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DTCoreText/DTCoreText.h>
@interface ZLCoreTextCell : DTAttributedTextCell

@property (nonatomic,copy) NSString *strInfo;
@property (nonatomic,assign) NSInteger section;

@end
