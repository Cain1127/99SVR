

/**自定义的UIWebView 8.0以下用UIWebView 8.0以上用WKwebView*/

#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
#else
#import <WebKit/WebKit.h>
#endif

@protocol AdaptiveWebViewDelegate <NSObject>

- (void)requestOperater:(NSString *)strId name:(NSString *)strName;

- (void)AdaptiveWebViewDidFailLoadWithError:(NSError *)error;

@end

@interface AdaptiveWebView : UIView

@property (nonatomic,assign) id<AdaptiveWebViewDelegate> delegate;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) WKWebView *wkWebView;

@end
