//
//  LPRefreshControl.m
//  LPRefreshControl
//
//  Created by litt1e-p on 16/1/9.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "LPRefreshControl.h"
#import <SVPullToRefresh.h>
#import "LPRefreshView.h"

@interface LPRefreshControl()
{
    UIScrollView *_scrollView;
}

@end

@implementation LPRefreshControl

+ (instancetype)sharedInstance
{
    static LPRefreshControl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (LPRefreshView *)customRefreshView:(RefreshState)state
{
    LPRefreshView *customView = [[LPRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    customView.refreshState = state;
    return customView;
}

- (void)addRefreshInView:(UIScrollView *)view
              atPosition:(RefreshPosition)position
             withHandler:(void (^)(void))handler
{
    
    if (position == RefreshPositionTop) {
        [view addPullToRefreshWithActionHandler:handler];
        [view.pullToRefreshView setCustomView:[self customRefreshView:RefreshStateStopped] forState:SVPullToRefreshStateStopped];
        [view.pullToRefreshView setCustomView:[self customRefreshView:RefreshStateTriggered] forState:SVPullToRefreshStateTriggered];
        [view.pullToRefreshView setCustomView:[self customRefreshView:RefreshStateLoading] forState:SVPullToRefreshStateLoading];
        _scrollView = view;
    } else if (position == RefreshPositionBottom) {
        [view addInfiniteScrollingWithActionHandler:handler];
        _scrollView = view;
    }
}

- (void)addRefreshInView:(UIScrollView *)view withTopHandler:(void (^)(void))topHandler andBottomHandler:(void (^)(void))bottomHandler
{
    [self addRefreshInView:view atPosition:RefreshPositionTop withHandler:topHandler];
    [self addRefreshInView:view atPosition:RefreshPositionBottom withHandler:bottomHandler];
}

- (void)triggerRefreshInView:(UIScrollView *)view atPosition:(RefreshPosition)position
{
    if (position == RefreshPositionTop) {
        [view triggerPullToRefresh];
    } else if (position == RefreshPositionBottom) {
        [view triggerInfiniteScrolling];
    }
}

- (void)stopAnimatingInView:(UIScrollView *)view atPosition:(RefreshPosition)position
{
    if (position == RefreshPositionTop) {
        [view.pullToRefreshView stopAnimating];
    } else if (position == RefreshPositionBottom) {
        [view.infiniteScrollingView stopAnimating];
    }
}
         
@end
