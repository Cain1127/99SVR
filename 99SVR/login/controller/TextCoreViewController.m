//
//  TestViewController.m
//  DTCoreText
//
//  Created by xia zhonglin  on 4/2/16.
//  Copyright © 2016 Drobnik.com. All rights reserved.
//

#import "TextCoreViewController.h"
#import <DTCoreText/DTCoreText.h>

@interface TextCoreViewController ()

@property (nonatomic,strong) DTAttributedTextView *attributedTextView;

@end

@implementation TextCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.attributedTextView = [DTAttributedTextView new];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
    self.attributedTextView.attributedString = attributedString;
    self.attributedTextView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.attributedTextView];
    self.attributedTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
