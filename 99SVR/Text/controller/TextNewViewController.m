//
//  TextNewViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//  观点类

#import "TextNewViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "NewDetailsViewController.h"
#import "TextNewCell.h"
#import "IdeaDetails.h"
#import "TextLiveModel.h"
#import "LiveCoreTextCell.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"
#import "TextTcpSocket.h"
#import "EmojiView.h"

@interface TextNewViewController ()<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryNew;
@property (nonatomic,strong) TextTcpSocket *textSocket;

@end

@implementation TextNewViewController

- (id)initWithSocket:(TextTcpSocket *)textSocket
{
    if(self = [super  init])
    {
        _textSocket = textSocket;
        return self;
    }
    return nil;
}

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
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
        [imageView sd_setImageWithURL:attachment.contentURL];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"];
        [imageView sd_setImageWithURL:url1];
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryNew.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strTextNew = @"textnewtableviewcellidentifier";
    
    TextNewCell *cell = [tableView dequeueReusableCellWithIdentifier:strTextNew];
    if(cell==nil)
    {
        cell = [[TextNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTextNew];
    }
    if(_aryNew.count > indexPath.section)
    {
        IdeaDetails *idea = [_aryNew objectAtIndex:indexPath.section];
        [cell setDetails:idea];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IdeaDetails *idea = [_aryNew objectAtIndex:indexPath.section];
    
    NewDetailsViewController *detailView = [[NewDetailsViewController alloc] initWithSocket:_textSocket model:idea];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNew) name:MESSAGE_TEXT_NEW_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqTextNewMessage) name:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
}

- (void)reqTextNewMessage
{
    [_textSocket reqNewList:0 count:20];
}

- (void)reloadNew
{
    _aryNew = _textSocket.aryNew;
    __weak TextNewViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadData];
    });
}

@end
