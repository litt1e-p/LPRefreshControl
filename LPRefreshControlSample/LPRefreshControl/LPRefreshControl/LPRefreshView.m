//
//  LPRefreshView.m
//  LPRefreshControl
//
//  Created by litt1e-p on 16/1/9.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "LPRefreshView.h"

@interface LPArrowView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end

@implementation LPArrowView
@synthesize arrowColor;

- (UIColor *)arrowColor
{
    if (arrowColor) return arrowColor;
    return [UIColor lightGrayColor]; // default Color
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    CGFloat padding = 5.f;
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(padding * 1.5, rect.size.height * 0.6)];
    [bezierPath addLineToPoint: CGPointMake(rect.size.width * 0.5, rect.size.height - padding)];
    [bezierPath addLineToPoint: CGPointMake(rect.size.width - padding * 1.5, rect.size.height * 0.6)];
    [self.arrowColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(rect.size.width * 0.5, rect.size.height - padding)];
    [bezier2Path addLineToPoint: CGPointMake(rect.size.width * 0.5, padding)];
    [self.arrowColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
}

@end

@interface LPRefreshView()
{
    RefreshState _state;
}

@end

@implementation LPRefreshView
@synthesize refreshState = _refreshState;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setRefreshState:(RefreshState)refreshState
{
    _refreshState = refreshState;
    [self setNeedsLayout];
}

- (RefreshState)refreshState
{
    return _refreshState;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSArray *titles = [@[NSLocalizedString(@"Pull to refresh...",),
                         NSLocalizedString(@"Release to refresh...",),
                         NSLocalizedString(@"Loading...",)]
                       mutableCopy];
    
    UILabel *descLabel      = [[UILabel alloc] init];
    descLabel.font          = [UIFont systemFontOfSize:13.f];
    descLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat maxDescLabelWidth = 0;
    for (int i = 0; i < titles.count; i++) {
        CGSize tempRect = [titles[i] sizeWithAttributes:@{NSFontAttributeName : descLabel.font}];
        if (maxDescLabelWidth) {
            maxDescLabelWidth = tempRect.width > maxDescLabelWidth ? tempRect.width : maxDescLabelWidth;
        } else {
            maxDescLabelWidth = tempRect.width;
        }
    }
    CGFloat imgWidth    = 30;
    CGFloat edgeWidth   = self.frame.size.width - maxDescLabelWidth - imgWidth;
    CGFloat edgePadding = edgeWidth > 0 ? edgeWidth / 2 : 0;
    descLabel.frame     = CGRectMake(edgePadding + imgWidth, 0, maxDescLabelWidth, self.frame.size.height);
    [self addSubview:descLabel];
    switch (self.refreshState) {
        case RefreshStateLoading:{
            descLabel.text = titles[2];
            UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            ind.frame = CGRectMake(edgePadding, 0, imgWidth, self.frame.size.height);
            [self addSubview:ind];
            [ind startAnimating];
            break;
        }
            
        case RefreshStateTriggered:
        case RefreshStateStopped:{
            descLabel.text = self.refreshState == RefreshStateStopped ? titles[0] : titles[1];
            LPArrowView *av = [[LPArrowView alloc] initWithFrame:CGRectMake(edgePadding, 0, imgWidth, self.frame.size.height)];
            self.refreshState == RefreshStateStopped ? : [self rotateView:av];
            [self addSubview:av];
            break;
        }
            
        default:
            break;
    }
}

- (void)rotateView:(UIView *)view
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    } completion:NULL];
}

@end
