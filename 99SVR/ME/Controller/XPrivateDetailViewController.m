//
//  XPrivateDetailViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XPrivateDetailViewController.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "XPrivateDetail.h"


@interface XPrivateDetailViewController ()<DTAttributedTextContentViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSCache *cache;
}
@property (nonatomic,assign) int privateId;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblAuthor;
@property (nonatomic,strong) UILabel *lblTime;
//@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,copy) XPrivateDetail *detail;
@property (nonatomic,strong) TQMeCustomizedModel *model;
@property (nonatomic,assign) int customId;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation XPrivateDetailViewController
- (id)initWithCustomId:(int)customId
{
    self = [super init];
    _customId = customId;
    return self;
}

- (id)initWithModel:(TQMeCustomizedModel *)model
{
    self = [super init];
    _model = model;
    _customId = [model.teamid intValue];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cache = [[NSCache alloc] init];
    [self setTitleText:@"私人定制详情"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 60)];
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(8, 8, kScreenWidth-16, 20)];
    [_lblTitle setTextColor:UIColorFromRGB(0x00)];
    [_lblTitle setFont:XCFONT(18)];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [tableHeader addSubview:_lblTitle];
    
    _lblAuthor = [[UILabel alloc] initWithFrame:Rect(8, _lblTitle.y+_lblTitle.height+8,150, 20)];
    [_lblAuthor setTextColor:UIColorFromRGB(0x919191)];
    [_lblAuthor setFont:XCFONT(13)];
    [tableHeader addSubview:_lblAuthor];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-160, _lblTitle.y+_lblTitle.height+8,152, 20)];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    [_lblTime setFont:XCFONT(13)];
    [_lblTime setTextAlignment:NSTextAlignmentRight];
    [tableHeader addSubview:_lblTime];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = tableHeader;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    _textView = [[DTAttributedTextView alloc] initWithFrame:Rect(8, 60, kScreenWidth-16,kScreenHeight-120)];
//    _textView.textDelegate = self;
//    _textView.scrollEnabled = YES;
//    [scrollView addSubview:_textView];
//    scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight-64);
}



- (void)setInfo:(NSNotification *)notify
{
    if (notify.object!=nil) {
        _detail = notify.object;
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.lblTitle setText:selfWeak.detail.title];
            [selfWeak.lblAuthor setText:selfWeak.detail.title];
            [selfWeak.lblTime setText:selfWeak.detail.publishtime];
            if (selfWeak.detail.content)
            {
                DLog(@"content:%@",selfWeak.detail.content);
                [selfWeak.tableView reloadData];
            }
        });
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInfo:) name:MESSAGE_PRIVATE_DETAIL_VC object:nil];
    [kHTTPSingle RequestPrivateServiceDetail:_customId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    DLog(@"dealloc!");
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        @WeakObj(self)
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             DTAttributedTextCell *cell = (DTAttributedTextCell*)attributedTextContentView.superview.superview;
             [selfWeak updateTextView:cell url:imageURL changeSize:image.size];
         }];
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


- (void)updateTextView:(DTAttributedTextCell*)text url:(NSURL*)url changeSize:(CGSize)size
{
    CGSize imageSize ;
    if (size.width>kScreenWidth) {
        imageSize.width = (kScreenWidth-20);
        CGFloat width = imageSize.width;
        imageSize.height = size.height/(size.width/width);
    }
    else
    {
        imageSize = size;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    BOOL didUpdate = NO;
    for (DTTextAttachment *oneAttachment in [text.attributedTextContextView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            didUpdate = YES;
        }
    }
    if (didUpdate)
    {
        //重新加载图片
        [text relayoutText];
        [_tableView reloadData];
    }
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    if (imageView.image)
    {
        NSMutableArray *aryIndex = [NSMutableArray array];
        Photo *_photo = [[Photo alloc] init];
        _photo.nId = 0;
        _photo.imgName = imageView.image;
        [aryIndex addObject:_photo];
        PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
        [photoControl show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (DTAttributedTextCell *)bufferTable:(UITableView*)tableView index:(NSIndexPath *)indexPath
{
    NSString *strkey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    DTAttributedTextCell *cell = [cache objectForKey:strkey];
    if (!cell)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:@"privateDetailController"];
        [cache setObject:cell forKey:cache];
    }
    if (!cell.attributedString)
    {
        [cell setHTMLString:_detail.content];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self bufferTable:tableView index:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self bufferTable:tableView index:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
    
}

@end
