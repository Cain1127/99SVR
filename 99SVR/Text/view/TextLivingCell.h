//
//  TextLivingCell.h
//  99SVR
//
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherModel;
@class TextRoomModel;

@interface TextLivingCell : UITableViewCell

- (void)setTeacherModel:(TeacherModel*)teacher;

- (void)setTextRoomModel:(TextRoomModel*)teacher;

@end
