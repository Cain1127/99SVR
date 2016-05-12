
#import "AdaptiveWebView.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

@interface AdaptiveWebView ()<UIWebViewDelegate,WKNavigationDelegate>
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
@property WebViewJavascriptBridge* bridge;
#else
@property WKWebViewJavascriptBridge *bridge;
#endif
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
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    self.webView.delegate = self;
#else
    [self.wkWebView loadRequest:urlRequest];
    self.wkWebView.navigationDelegate = self;
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
#endif
    @WeakObj(self)
    [_bridge registerHandler:@"RequestOperater" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        NSLog(@"RequestInfo: %@", data);
        if([data isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = data;
            if ([dict objectForKey:@"nId"] && [dict objectForKey:@"vcname"])
            {
                NSString *strId = [dict objectForKey:@"nId"];
                NSString *vcName = [dict objectForKey:@"vcname"];
                if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(requestOperater:name:)])
                {
                    [selfWeak.delegate requestOperater:strId name:vcName];
                }
            }
        }
    }];
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
        _bridge = nil;
    }
    
    if (_wkWebView) {
        _wkWebView = nil;
        _bridge = nil;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"test:%@",[request.URL absoluteString]);
    return YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    NSString *promptCode = [NSString stringWithFormat:@"openStockRecord(\"%@\")"];
//    [_wkWebView evaluateJavaScript:promptCode completionHandler:^(id object, NSError *error) { }];
}

@end
