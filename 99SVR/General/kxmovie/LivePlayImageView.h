//
//  LivePlayImageView.h
//  99SVR
//
//  Created by xia zhonglin  on 5/17/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePlayImageView : UIImageView

@property (nonatomic,strong) UILabel *lblContent;

@property (nonatomic,assign) int nMode;


- (void)loadDefault;

- (void)loadAudioModel;

- (void)removeImgView;

@end
