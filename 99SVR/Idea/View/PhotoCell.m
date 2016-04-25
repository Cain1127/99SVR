//
//  PhotoCell.m
//  01-UICollectionView基本使用
//
//  Created by 1 on 15/12/29.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoCell

- (void)setImage:(UIImage *)image
{
    _image = image;
 
    self.imageView.image = image;
}
@end
