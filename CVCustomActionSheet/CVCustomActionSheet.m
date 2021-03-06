//
//  CVCustomActionSheet.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import "CVCustomActionSheet.h"
#import "CVCustomAction.h"
#import "CVCustomActionSheetButtonConfiguration.h"
#import "CVCustomActionSheetButton.h"

static CGFloat const ButtonHeight = 44;
static CGFloat const ButtonMargin = 8;
static NSInteger const MaxVisibleButtons = 4;
static CGFloat const FallbackEffectViewOpacity = 0.75;

static CGFloat const FadeInOutDuration = 0.25;
static CGFloat const FadeInOutSpringDamping = 1.0;
static CGFloat const FadeInOutInitialSpringVelocity = 1.0;

static CGFloat const SnapDelay = 0.1;
static CGFloat const ScrollViewSnapDamping = 0.25;
static CGFloat const CancelButtonSnapDamping = 0.35;

@interface CVCustomActionSheet () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIVisualEffectView *blurredBackgroundView;
@property (nonatomic) UIView *transparentBackgroundView;
@property (nonatomic) CVCustomActionSheetButton *cancelButton;
@property (nonatomic) UIDynamicAnimator *animator;

@property (nonatomic) NSMutableArray *actions;
@property (nonatomic) NSMutableDictionary *styles;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;

@property (nonatomic, readonly) CGRect screenBounds;
@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, readonly) CVCustomAction *cancelAction;

@end

@implementation CVCustomActionSheet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actions = [[NSMutableArray alloc] init];
        self.styles = [[NSMutableDictionary alloc] init];
        self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.window];
        
        if (NSClassFromString(@"UIVisualEffectView")) {
            UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _blurredBackgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
            _blurredBackgroundView.alpha = 0;
            _blurredBackgroundView.frame = self.screenBounds;
            [self.window addSubview:_blurredBackgroundView];
        } else {
            _transparentBackgroundView = [[UIView alloc] initWithFrame:self.screenBounds];
            _transparentBackgroundView.backgroundColor = [UIColor blackColor];
            _transparentBackgroundView.alpha = 0;
            [self.window addSubview:_transparentBackgroundView];
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.screenBounds];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.blurredBackgroundView addGestureRecognizer:tapGesture];
        [self.transparentBackgroundView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)addAction:(CVCustomAction *)action
{
    NSParameterAssert(action);
    [self.actions addObject:action];
}

- (void)setup
{
    UIView *contentView = [self contentView];
    
    // Cancel button
    self.cancelButton = [[CVCustomActionSheetButton alloc] initWithAction:^{
        for (CVCustomAction *action in self.actions) {
            if (action.type == CVCustomActionTypeCancel) {
                return action;
            }
        }
        return [CVCustomAction new];
    }() defaultConfiguration:[self configurationForType:CVCustomActionTypeCancel selected:NO]
                                                    selectedConfiguration:[self configurationForType:CVCustomActionTypeCancel selected:YES]];
    
    self.cancelButton.frame = CGRectMake(ButtonMargin,
                                         self.screenBounds.size.height - ButtonMargin - ButtonHeight,
                                         contentView.frame.size.width,
                                         ButtonHeight);
    
    [self.cancelButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.cancelButton];
    
    // Scroll View
    CVCustomActionSheetButtonConfiguration *defaultConfig = [self configurationForType:CVCustomActionTypeDefault selected:NO];
    self.scrollView.backgroundColor = defaultConfig.backgroundColor;
    self.scrollView.contentSize = contentView.frame.size;
    self.scrollView.frame = ^{
        CGRect frame;
        frame.size.width = contentView.frame.size.width;
        frame.size.height = MIN(ButtonHeight * MaxVisibleButtons, contentView.frame.size.height);
        frame.origin.x = ButtonMargin;
        frame.origin.y = CGRectGetMinY(_cancelButton.frame) - ButtonMargin - frame.size.height;
        return frame;
    }();
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView addSubview:contentView];
    [self.window addSubview:self.scrollView];
}

- (void)show
{
    NSAssert([self occurrencesOfActionType:CVCustomActionTypeDefault] > 0, @"Before presenting, you must have at least 1 default action.");
    NSAssert([self occurrencesOfActionType:CVCustomActionTypeCancel] == 1, @"Before presenting, you must have a cancel button.");
    
    [self setup];
    
    // Hide
    CGRect finalScrollViewFrame = self.scrollView.frame;
    CGRect finalCancelButtonFrame = self.cancelButton.frame;
    CGFloat offset = CGRectGetMinY(self.scrollView.frame);
    
    self.blurredBackgroundView.alpha = 0;
    self.transparentBackgroundView.alpha = 0;
    
    self.scrollView.frame = ({
        CGRect frame = self.scrollView.frame;
        frame.origin.y += offset;
        frame;
    });
    
    self.cancelButton.frame = ({
        CGRect frame = self.cancelButton.frame;
        frame.origin.y += offset;
        frame;
    });
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // Fade in
    [UIView animateWithDuration:FadeInOutDuration
                          delay:0
         usingSpringWithDamping:FadeInOutSpringDamping
          initialSpringVelocity:FadeInOutInitialSpringVelocity
                        options:0
                     animations:^{
                         
                         self.blurredBackgroundView.alpha = 1;
                         self.transparentBackgroundView.alpha = FallbackEffectViewOpacity;
                     } completion:nil];
    
    // Animate in
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SnapDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGPoint finalScrollViewCenter = CGPointMake(CGRectGetMidX(finalScrollViewFrame), CGRectGetMidY(finalScrollViewFrame));
        CGPoint finalCancelButtonCenter = CGPointMake(CGRectGetMidX(finalCancelButtonFrame), CGRectGetMidY(finalCancelButtonFrame));
        NSArray *items = @[self.scrollView, self.cancelButton];
        
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        [self.animator addBehavior:collisionBehavior];
        
        UISnapBehavior *scrollViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.scrollView snapToPoint:finalScrollViewCenter];
        scrollViewSnapBehavior.damping = ScrollViewSnapDamping;
        [self.animator addBehavior:scrollViewSnapBehavior];
        
        UISnapBehavior *cancelButtonSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.cancelButton snapToPoint:finalCancelButtonCenter];
        cancelButtonSnapBehavior.damping = CancelButtonSnapDamping;
        [self.animator addBehavior:cancelButtonSnapBehavior];
        
        UIDynamicItemBehavior *dynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
        dynamicBehavior.allowsRotation = NO;
        [self.animator addBehavior:dynamicBehavior];
    });
}

- (void)dismiss
{
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle];
    
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:FadeInOutDuration
                          delay:0
         usingSpringWithDamping:FadeInOutSpringDamping
          initialSpringVelocity:FadeInOutInitialSpringVelocity
                        options:0
                     animations:^{
                         
                         self.blurredBackgroundView.alpha = 0;
                         self.transparentBackgroundView.alpha = 0;
                         self.scrollView.alpha = 0;
                         self.cancelButton.alpha = 0;
                     } completion:^(BOOL finished) {
                         
                         [self.cancelButton removeFromSuperview];
                         [self.scrollView removeFromSuperview];
                         [self.blurredBackgroundView removeFromSuperview];
                         [self.transparentBackgroundView removeFromSuperview];
                         
                         if (self.dismissBlock) {
                             self.dismissBlock();
                         }
                     }];
    
}

- (void)selectedButton:(id)sender
{
    CVCustomActionSheetButton *button = (CVCustomActionSheetButton *)sender;
    
    if (button.action.handler) {
        button.action.handler(button.action);
    }
    
    [self dismiss];
}

#pragma mark - Styling

- (NSString *)configKeyForType:(CVCustomActionType)type
                      selected:(BOOL)selected
{
    return [NSString stringWithFormat:@"%lu-%d", (long)type, selected ? 1 : 0];
}

- (void)setButtonConfiguration:(CVCustomActionSheetButtonConfiguration *)buttonConfiguration
                       forType:(CVCustomActionType)type
                      selected:(BOOL)selected
{
    NSParameterAssert(buttonConfiguration);
    NSParameterAssert(type);
    NSAssert([buttonConfiguration isKindOfClass:[CVCustomActionSheetButtonConfiguration class]], @"Not the correct class.");
    
    NSString *key = [self configKeyForType:type selected:selected];
    self.styles[key] = buttonConfiguration;
}

- (CVCustomActionSheetButtonConfiguration *)configurationForType:(CVCustomActionType)type
                                                        selected:(BOOL)selected
{
    NSString *key = [self configKeyForType:type selected:selected];
    if ([self.styles.allKeys containsObject:key]) {
        return self.styles[key];
    }
    return [CVCustomActionSheetButtonConfiguration defaultConfigurationForType:type selected:selected];
}

#pragma mark - Buttons

- (UIView *)contentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:^{
        CGRect frame = CGRectZero;
        frame.size.width = CGRectGetWidth(self.screenBounds) - (ButtonMargin * 2);
        frame.size.height = ButtonHeight * [self occurrencesOfActionType:CVCustomActionTypeDefault];
        return frame;
    }()];
    
    NSInteger i = 0;
    for (CVCustomAction *action in self.actions) {
        if (action.type == CVCustomActionTypeCancel) {
            continue;
        }
        
        CVCustomActionSheetButton *button = [[CVCustomActionSheetButton alloc] initWithAction:action
                                                                         defaultConfiguration:[self configurationForType:action.type selected:NO]
                                                                        selectedConfiguration:[self configurationForType:action.type selected:YES]];
        button.frame = CGRectMake(0, ButtonHeight * i, CGRectGetWidth(contentView.bounds), ButtonHeight);
        [button addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        
        i++;
    }
    
    // Draw the lines
    for (int i = 0; i < self.actions.count; i++) {
        CVCustomActionSheetButtonConfiguration *config = [self configurationForType:CVCustomActionTypeDefault selected:YES];
        CALayer *line = [CALayer layer];
        line.backgroundColor = config.backgroundColor.CGColor;
        line.frame = CGRectMake(0, i * ButtonHeight, CGRectGetWidth(contentView.bounds), 1);
        [contentView.layer addSublayer:line];
    }
    
    return contentView;
}

#pragma mark Helpers

- (CVCustomAction *)cancelAction
{
    for (CVCustomAction *action in self.actions) {
        if (action.type == CVCustomActionTypeCancel) {
            return action;
        }
    }
    return nil;
}

- (NSInteger)occurrencesOfActionType:(CVCustomActionType)type
{
    NSInteger count = 0;
    for (CVCustomAction *action in self.actions) {
        if (action.type == type) {
            count++;
        }
    }
    return count;
}

- (UIWindow *)window
{
    return [UIApplication sharedApplication].keyWindow;
}

- (CGRect)screenBounds
{
    return [[UIScreen mainScreen] bounds];
}

@end
