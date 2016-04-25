//
//  TableViewCell.h
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewCellDelegate <NSObject>

-(void)tableViewCellWithClickButton:(UIButton *)button row:(NSInteger)row;

@end

@interface TableViewCell : UITableViewCell
/**背景图*/
@property (weak, nonatomic) IBOutlet UIView *BackgroundView;

@property (nonatomic,assign)NSInteger row;
@property (nonatomic,weak)id <TableViewCellDelegate>delegate;

@end
