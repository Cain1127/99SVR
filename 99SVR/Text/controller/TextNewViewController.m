//
//  TextNewViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextNewViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"

@interface TextNewViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_dictIcon;
}
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation TextNewViewController

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIBody];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error,
                                                                        SDImageCacheType cacheType, NSURL *imageURL)
         {
             
         }];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        //[$3$]  [$999$] [$62$]
        if([strName intValue]==999 || [strName intValue]<=34)
        {
            [self findImage:strName imgView:imageView];
        }
        else
        {
            [self findImage:@"8" imgView:imageView];
        }
        return imageView;
    }
    return nil;
}

- (void)findImage:(NSString *)strName imgView:(UIImageView *)imageView
{
    UIImage *image = [_dictIcon objectForKey:strName];
    if (image)
    {
        [imageView setImage:image];
    }
    else
    {
        image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"]];
        [_dictIcon setObject:image forKey:strName];
        [imageView setImage:image];
    }
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    NSMutableArray *aryIndex = [NSMutableArray array];
    Photo *_photo = [[Photo alloc] init];
    _photo.nId = 0;
    _photo.imgName = imageView.image;
    [aryIndex addObject:_photo];
    PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
    [photoControl show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
