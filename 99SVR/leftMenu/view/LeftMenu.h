//
//  LeftMenu.h
//  99SVR
//
//  Created by Jiangys on 16/3/15.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuDegelate <NSObject>

-(void)leftMenuDidSeletedAtRow:(NSInteger)row title:(NSString *)title vc:(UIViewController *)vc;
-(void)leftMenuIconDidClick;

@end

@interface LeftMenu : UIView

@property (nonatomic,weak)id <LeftMenuDegelate> degelate;

@property (nonatomic,strong) NSArray *lists;

@end
