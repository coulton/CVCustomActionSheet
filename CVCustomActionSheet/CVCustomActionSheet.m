//
//  CVCustomActionSheet.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import "CVCustomActionSheet.h"

CGFloat const buttonHeight = 44.0f;
CGFloat const buttonMargin = 15.0f;
NSInteger const buttonCountMax = 4;

#define kScreenSize [[UIScreen mainScreen] bounds]
#define kButtonWidth kScreenSize.size.width - (buttonMargin * 2)

@interface CVCustomActionSheet () {
    NSString *cancelTitle;
    NSArray *optionTitles;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;

@property (nonatomic, strong) CVOptionPressed optionCompletion;
@property (nonatomic, strong) CVCancelPressed cancelCompletion;
@property (nonatomic, strong) CVCustomActionSheet *actionSheet;
@property (nonatomic, readonly) UIButton *cancelButton, *optionButton;
@end

@implementation CVCustomActionSheet

- (void)setDefaults
{
    self.buttonBackgroundColor = [UIColor whiteColor];
    self.buttonTextColor = [UIColor blackColor];
    self.selectedButtonBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.selectedButtonTextColor = [UIColor blackColor];
    
    self.cancelBackgroundColor = [UIColor blueColor];
    self.cancelTextColor = [UIColor whiteColor];
    self.selectedCancelBackgroundColor = [UIColor blueColor];
    self.selectedCancelTextColor = [UIColor whiteColor];
    
    self.buttonFont = [UIFont systemFontOfSize:15];
    self.lineColor = [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (id)initWithOptions:(NSArray *)options
 andCancelButtonTitle:(NSString*)cancelButtonTitle
{
    self = [super init];
    if (self) {
        cancelTitle = cancelButtonTitle;
        [self setDefaults];
        
        self.window = [UIApplication sharedApplication].keyWindow;
        self.actionSheet = self;
        optionTitles = options;
        
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.backgroundView.frame = kScreenSize;
        [self.window addSubview:self.backgroundView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
        [self.backgroundView addGestureRecognizer:tapGesture];
        
        self.contentView = [[UIView alloc] initWithFrame:kScreenSize];
        
        if ([options count] > buttonCountMax) {
            CGRect frame = CGRectMake(buttonMargin, 0, kButtonWidth, buttonHeight * buttonCountMax);
            self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
            self.scrollView.backgroundColor = self.buttonBackgroundColor;
            self.scrollView.delegate = self.actionSheet;
            self.scrollView.showsVerticalScrollIndicator = NO;
            
            self.scrollView.contentSize = CGSizeMake(kButtonWidth, ((buttonHeight + 1) * [options count]) - 1);
            [self.contentView addSubview:self.scrollView];
        }
        
        int i = 0;
        for (NSString *buttonTitle in options) {
            
            // Single option
            UIButton *optionButton = [self optionButton];
            [optionButton setTitle:buttonTitle forState:UIControlStateNormal];
            
            if ([options count] > buttonCountMax) {
                
                optionButton.frame = CGRectMake(0, i * (buttonHeight + 1), kButtonWidth, buttonHeight);
                [self.scrollView addSubview:optionButton];
            } else {
                
                optionButton.frame = CGRectMake(buttonMargin, i * (buttonHeight + 1), kButtonWidth, buttonHeight);
                [self.contentView addSubview:optionButton];
            }
            
            // Line
            if (i < [options count] - 1) {
                CALayer *line = [CALayer layer];
                line.backgroundColor = self.lineColor.CGColor;
                
                if ([options count] > buttonCountMax) {
                    
                    line.frame = CGRectMake(0, optionButton.frame.origin.y + buttonHeight, kButtonWidth, 1);
                    [self.scrollView.layer addSublayer:line];
                } else {
                    
                    line.frame = CGRectMake(buttonMargin, optionButton.frame.origin.y + buttonHeight, kButtonWidth, 1);
                    [self.contentView.layer addSublayer:line];
                }
            }
            
            i++;
        }
        
        if ([options count] > buttonCountMax) {
            
            CALayer *lineTop = [CALayer layer];
            lineTop.backgroundColor = self.lineColor.CGColor;
            lineTop.frame = CGRectMake(0, -1, kButtonWidth, 1);
            [self.scrollView.layer addSublayer:lineTop];
            
            CALayer *lineBottom = [CALayer layer];
            lineBottom.backgroundColor = self.lineColor.CGColor;
            lineBottom.frame = CGRectMake(0, self.scrollView.contentSize.height, kButtonWidth, 1);
            [self.scrollView.layer addSublayer:lineBottom];
        }
        
        // Cancel
        UIButton *cancel = [self cancelButton];
        if ([options count] > buttonCountMax) {
            cancel.frame = CGRectMake(buttonMargin, buttonCountMax * (buttonHeight + 1) + (buttonMargin/2), kButtonWidth, buttonHeight);
        } else {
            cancel.frame = CGRectMake(buttonMargin, (i * (buttonHeight + 1)) + (buttonMargin/2), kButtonWidth, buttonHeight);
        }
        [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.contentView addSubview:cancel];
        
        // Content frame
        CGRect frame = self.contentView.frame;
        frame.size.height = cancel.frame.origin.y + cancel.frame.size.height;
        frame.origin.y = kScreenSize.size.height;
        self.contentView.frame = frame;
        [self.window addSubview:self.contentView];
    
    }
    return self;
}

#pragma mark Properties

- (UIButton *)cancelButton
{
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
    cancel.titleLabel.font = self.buttonFont;
    cancel.backgroundColor = self.cancelBackgroundColor;
    
    [cancel addTarget:self.actionSheet
               action:@selector(cancel:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [cancel addTarget:self.actionSheet
               action:@selector(buttonPress:)
     forControlEvents:UIControlEventTouchDown];
    
    [cancel addTarget:self.actionSheet
               action:@selector(buttonRelease:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [cancel addTarget:self.actionSheet
               action:@selector(buttonRelease:)
     forControlEvents:UIControlEventTouchUpOutside];
    
    return cancel;
}

- (UIButton *)optionButton
{
    UIButton *option = [UIButton buttonWithType:UIButtonTypeCustom];
    [option setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    option.titleLabel.font = self.buttonFont;
    option.backgroundColor = self.buttonBackgroundColor;
    
    [option addTarget:self.actionSheet
               action:@selector(buttonPress:)
     forControlEvents:UIControlEventTouchDown];
    
    [option addTarget:self.actionSheet
               action:@selector(buttonRelease:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [option addTarget:self.actionSheet
               action:@selector(buttonRelease:)
     forControlEvents:UIControlEventTouchUpOutside];
    
    [option addTarget:self.actionSheet
               action:@selector(close:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return option;
}

#pragma mark - Buttons
#pragma mark Actions

- (void)show:(CVCancelPressed)cancelBlock
optionPressed:(CVOptionPressed)optionBlock
{
    self.cancelCompletion = cancelBlock;
    self.optionCompletion = optionBlock;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         
                         self.contentView.alpha = 1.0;
                         self.backgroundView.alpha = 1.0f;
                         
                     } completion:nil];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                            
                            CGRect frame = self.contentView.frame;
                            frame.origin.y = kScreenSize.size.height - self.contentView.frame.size.height - buttonMargin;
                            self.contentView.frame = frame;
                            
                        }
                     completion:nil];
}

- (void)dismiss:(void(^)())completed
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         
                         self.backgroundView.alpha = 0.0;
                         
                         CGRect frame = self.contentView.frame;
                         frame.origin.y = kScreenSize.size.height;
                         self.contentView.frame = frame;
                         
                     }
                     completion:^(BOOL finish){
                         
                         [self.backgroundView removeFromSuperview];
                         self.backgroundView = nil;
                         self.actionSheet = nil;
                        
                         if (completed) completed();
                         
                     }];
}

- (void)close:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSString *buttonTitle = button.titleLabel.text;
    
    if (![optionTitles containsObject:buttonTitle]) return;
    NSInteger buttonIndex = [optionTitles indexOfObject:buttonTitle];
    
    [self dismiss:^{
        
        if (self.optionCompletion)
            self.optionCompletion(buttonIndex, button.titleLabel.text);
    }];
}

- (void)cancel:(id)sender
{
    [self dismiss:^{
        
        if (self.cancelCompletion) self.cancelCompletion();
    }];
}

#pragma mark Highlighting

- (void)scrollViewWillBeginDragging:(UIScrollView *)draggedScrollView
{
    for (UIView *subview in self.scrollView.subviews) {
        
        if (subview.tag == 0) continue;
        [self buttonRelease:subview];
    }
}

- (void)buttonPress:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if ([button.titleLabel.text isEqualToString:cancelTitle]) {
        [button setTitleColor:self.selectedCancelTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.selectedCancelBackgroundColor];
    } else {
        [button setTitleColor:self.selectedButtonTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.selectedButtonBackgroundColor];
    }
}

- (void)buttonRelease:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if ([button.titleLabel.text isEqualToString:cancelTitle]) {
        [button setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.cancelBackgroundColor];
    } else {
        [button setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.buttonBackgroundColor];
    }
}

@end
