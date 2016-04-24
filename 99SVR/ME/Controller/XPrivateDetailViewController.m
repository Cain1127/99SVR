//
//  XPrivateDetailViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XPrivateDetailViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "XPrivateDetail.h"

@interface XPrivateDetailViewController ()<DTAttributedTextContentViewDelegate>
{
    
}
@property (nonatomic,assign) int privateId;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblAuthor;
@property (nonatomic,strong) UILabel *lblTime;
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,copy) XPrivateDetail *detail;
@property (nonatomic,strong) TQMeCustomizedModel *model;
@property (nonatomic,assign) int customId;

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
    [self setTitleText:@"私人定制详情"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(8, 70, kScreenWidth-16, 20)];
    [_lblTitle setTextColor:UIColorFromRGB(0x00)];
    [_lblTitle setFont:XCFONT(18)];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lblTitle];
    
    _lblAuthor = [[UILabel alloc] initWithFrame:Rect(8, 95,150, 20)];
    [_lblAuthor setTextColor:UIColorFromRGB(0x919191)];
    [_lblAuthor setFont:XCFONT(13)];
    [self.view addSubview:_lblAuthor];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-160, 95,152, 20)];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    [_lblTime setFont:XCFONT(13)];
    [_lblTime setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:_lblTime];
    
    _textView = [[DTAttributedTextView alloc] initWithFrame:Rect(8, 120, kScreenWidth-16,kScreenHeight-120)];
    _textView.textDelegate = self;
    [self.view addSubview:_textView];
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
            if (selfWeak.detail.content) {
                NSAttributedString *attribute = [[NSAttributedString alloc] initWithHTMLData:[selfWeak.detail.content dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
                [selfWeak.textView setAttributedString:attribute];
            }
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInfo:) name:MESSAGE_PRIVATE_DETAIL_VC object:nil];
    [kHTTPSingle RequestPrivateServiceDetail:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
