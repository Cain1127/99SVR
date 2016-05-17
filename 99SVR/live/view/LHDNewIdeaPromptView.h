

/**房间内 新的专家观点提示的view*/


#import <UIKit/UIKit.h>

@protocol LHDNewIdeaPromptViewDelegate <NSObject>

-(void)clickInViewHanle;

@end

@interface LHDNewIdeaPromptView : UIImageView
@property (nonatomic , weak) id<LHDNewIdeaPromptViewDelegate>delegate;
@property (nonatomic , assign) __block BOOL isShow;

@end
