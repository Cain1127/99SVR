
#import "AdaptiveWebView.h"


@interface AdaptiveWebView ()





@end

@implementation AdaptiveWebView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setUrl:(NSString *)url{
    _url = url;
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    [self.webView loadRequest:urlRequest];

#else
    [self.wkWebView loadRequest:urlRequest];
#endif
    
}



-(UIWebView *)webView{
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}];
        [self addSubview:_webView];
    }
    return _webView;
}

-(WKWebView *)wkWebView{
    
    if (!_wkWebView) {
        
        _wkWebView = [[WKWebView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}];
    
        
        [self addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (void)dealloc
{
    
    if (_webView) {
        _webView = nil;
    }
    
    if (_wkWebView) {
        _wkWebView = nil;
    }
}



@end
