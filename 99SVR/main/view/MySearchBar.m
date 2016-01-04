//
//  MySearchBar.m
//  WatchAPPUI
//
//  Created by zouyb on 15/9/15.
//  Copyright (c) 2015年 zouyb. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [view removeFromSuperview];
                break;
            }
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0)
            {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

@end
