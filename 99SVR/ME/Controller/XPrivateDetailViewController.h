//
//  XPrivateDetailViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "TQMeCustomizedModel.h"

@interface XPrivateDetailViewController : CustomViewController

- (id)initWithModel:(TQMeCustomizedModel *)model;
- (id)initWithCustomId:(int )customId;

@end
