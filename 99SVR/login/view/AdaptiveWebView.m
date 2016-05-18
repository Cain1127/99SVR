
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
    [_bridge setWebViewDelegate:self];
#else
    [self.wkWebView loadRequest:urlRequest];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
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
    
    [_bridge registerHandler:@"RequestVideo" handler:^(id data, WVJBResponseCallback responseCallback)
     {
         NSLog(@"RequestVideo: %@", data);
         if([data isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = data;
             if ([dict objectForKey:@"path"])
             {
                 NSString *strPath = [dict objectForKey:@"path"];
                 if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(playUrlVideo:)])
                 {
                     [selfWeak.delegate playUrlVideo:strPath];
                 }
             }
         }
     }];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}];
        _webView.delegate = self;
        [self addSubview:_webView];
    }
    return _webView;
}

-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}];
        _wkWebView.navigationDelegate = self;
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
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
        [_wkWebView removeObserver:self forKeyPath:@"title"];
        _wkWebView = nil;
        _bridge = nil;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSString *title = [change objectForKey:@"new"];
    if ([self.delegate respondsToSelector:@selector(refreshTitle:)]) {
        [self.delegate refreshTitle:title];
    }
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(AdaptiveWebViewDidFailLoadWithError:)]) {
        [self.delegate AdaptiveWebViewDidFailLoadWithError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.delegate respondsToSelector:@selector(refreshTitle:)]) {
        [self.delegate refreshTitle:title];
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error
{
    DLog(@"didFailNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(AdaptiveWebViewDidFailLoadWithError:)]) {
        [self.delegate AdaptiveWebViewDidFailLoadWithError:error];
    }
}

@end
