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

@interface CVCustomActionSheet () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIVisualEffectView *backgroundView;
@property (nonatomic) NSMutableArray *actions;
@property (nonatomic) NSMutableDictionary *styles;
@property (nonatomic) CVCustomActionSheetButton *cancelButton;
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
        
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _backgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backgroundView.alpha = 0;
        _backgroundView.frame = [[UIScreen mainScreen] bounds];
        [self.window addSubview:_backgroundView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.screenBounds];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.backgroundView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)addAction:(CVCustomAction *)action
{
    NSParameterAssert(action);
    [self.actions addObject:action];
}

- (void)show
{
    NSAssert([self occurrencesOfActionType:CVCustomActionTypeDefault] > 0, @"Before presenting, you must have at least 1 default action.");
    NSAssert([self occurrencesOfActionType:CVCustomActionTypeCancel] == 1, @"Before presenting, you must have a cancel button.");
    
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
    
    self.backgroundView.alpha = 1;
}

- (void)dismiss
{
    [self.cancelButton removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
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

- (void)setButtonConfiguration:(CVCustomActionSheetButtonConfiguration *)buttonConfiguration
                       forType:(CVCustomActionType)type
                      selected:(BOOL)selected
{
    NSParameterAssert(buttonConfiguration);
    NSParameterAssert(type);
}

- (CVCustomActionSheetButtonConfiguration *)configurationForType:(CVCustomActionType)type
                                                        selected:(BOOL)selected
{
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
