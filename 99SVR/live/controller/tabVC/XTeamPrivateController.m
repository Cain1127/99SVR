//
//  XTeamPrivateController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamPrivateController.h"
#import <DTCoreText/DTCoreText.h>
@interface XTeamPrivateController()<DTAttributedTextContentViewDelegate>
{
    
}

@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) RoomHttp *room;

@end

@implementation XTeamPrivateController

- (id)initWithModel:(RoomHttp*)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
    _textView = [[DTAttributedTextView alloc] initWithFrame:Rect(8, 10, kScreenWidth-16, self.view.height-8)];
    _textView.textDelegate = self;
    [self.view addSubview:_textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWhatsPrivate:) name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];
    [kHTTPSingle RequestWhatIsPrivateService];
}

- (void)loadWhatsPrivate:(NSNotification *)notify
{
    NSString *strInfo = notify.object;
    if(strInfo){
        _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    }
}




@end
