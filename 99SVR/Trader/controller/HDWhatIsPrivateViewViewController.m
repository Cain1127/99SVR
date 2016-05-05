
#import "HDWhatIsPrivateViewViewController.h"
#import "ZLWhatIsPrivateView.h"
@interface HDWhatIsPrivateViewViewController ()
@property (nonatomic , strong) ZLWhatIsPrivateView *whatPrivate;
@end

@implementation HDWhatIsPrivateViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_Bg_Gay;
    self.txtTitle.text = @"什么是私人定制";
    self.whatPrivate = [[ZLWhatIsPrivateView alloc] initWithFrame:Rect(0, 64, kScreenWidth, self.view.height-64) withViewTag:1];
    [self.view addSubview:self.whatPrivate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWhatsPrivate:) name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];
    [kHTTPSingle RequestWhatIsPrivateService];
}

- (void)loadWhatsPrivate:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1)
    {
        NSString *strInfo = dict[@"data"];
        if(strInfo)
        {
            [self.whatPrivate setContent:strInfo];
        }
    }
}

-(void)MarchBackLeft{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{
    
    DLog(@"delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];

}


@end
