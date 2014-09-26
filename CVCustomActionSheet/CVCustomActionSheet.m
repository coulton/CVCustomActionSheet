//
//  CVCustomActionSheet.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import "CVCustomActionSheet.h"
#import "UIImage+ImageEffects.h"

@interface CVCustomActionSheet ()
@property (nonatomic, retain) UIView *content;
@property (nonatomic, retain) UIButton *background;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *otherButtonTitles;
@end

@implementation CVCustomActionSheet

- (id)init
{
    self = [super init];
    if (self) {
    
        // Defaults
        self.buttonBackgroundColor = [UIColor whiteColor];
        self.buttonTextColor = [UIColor blackColor];
        self.selectedButtonBackgroundColor = [UIColor lightGrayColor];
        self.selectedButtonTextColor = [UIColor blackColor];
        
        self.cancelBackgroundColor = [UIColor blueColor];
        self.cancelTextColor = [UIColor whiteColor];
        self.selectedCancelBackgroundColor = [UIColor blueColor];
        self.selectedCancelTextColor = [UIColor whiteColor];
        
        self.buttonFont = [UIFont systemFontOfSize:15];
        self.lineColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (id)initWithDelegate:(id<CVCustomActionSheetDelegate>)delegate
     cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.window = [UIApplication sharedApplication].keyWindow;
        self.otherButtonTitles = otherButtonTitles;
        self.actionSheet = self;
        
        // Blur Background
        UIImage *image = nil;
        UIGraphicsBeginImageContextWithOptions(_window.bounds.size, NO, 0);
        [_window drawViewHierarchyInRect:_window.bounds afterScreenUpdates:NO];
        image = [UIGraphicsGetImageFromCurrentImageContext() applyBlurWithRadius:CV_BACKGROUND_RADIUS tintColor:CV_BACKGROUND_TINT saturationDeltaFactor:1 maskImage:nil];
        UIGraphicsEndImageContext();
            
        _background = [UIButton buttonWithType:UIButtonTypeCustom];
        [_background setFrame:[[UIScreen mainScreen] bounds]];
        [_background setBackgroundColor:[UIColor clearColor]];
        [_background setImage:image forState:UIControlStateNormal];
        [_background setAdjustsImageWhenHighlighted:NO];
        [_background setAlpha:0];
        [_background addTarget:_actionSheet action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_window addSubview:_background];
        
        self.content = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        int i = 0;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, 290, CV_BUTTON_HEIGHT * CV_BUTTON_COUNT_MAX)];
        _scrollView.backgroundColor = self.buttonBackgroundColor;
        _scrollView.delegate = _actionSheet;
        _scrollView.showsVerticalScrollIndicator = NO;
        if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
            _scrollView.contentSize = CGSizeMake(290, ((CV_BUTTON_HEIGHT + 1) * [otherButtonTitles count]) - 1);
            [self.content addSubview:_scrollView];
        }
        
        for (NSString *string in otherButtonTitles) {
            
            UIButton *option = [UIButton buttonWithType:UIButtonTypeCustom];
            option.frame = CGRectMake(15, i * (CV_BUTTON_HEIGHT + 1), 290, CV_BUTTON_HEIGHT);
            [option setTitle:string forState:UIControlStateNormal];
            [option setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
            option.titleLabel.font = self.buttonFont;
            option.backgroundColor = self.buttonBackgroundColor;
            option.tag = i + 2;
            [option addTarget:_actionSheet action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
            [option addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
            [option addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
            [option addTarget:_actionSheet action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
                
                // Add to scroll view, if there are enough buttons to scroll
                option.frame = CGRectMake(0, i * (CV_BUTTON_HEIGHT + 1), 290, CV_BUTTON_HEIGHT);
                [_scrollView addSubview:option];
                
            } else {
                
                // Add to the main content view, if there aren't enough buttons to scroll
                [self.content addSubview:option];
                
            }
            
            // Add a line, if it's not the last entry
            if (i + 1 < [otherButtonTitles count]) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, option.frame.origin.y + CV_BUTTON_HEIGHT, 290, 1)];
                line.backgroundColor = self.lineColor;
                
                if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
                    line.frame = CGRectMake(0, option.frame.origin.y + CV_BUTTON_HEIGHT, 290, 1);
                    [_scrollView addSubview:line];
                } else {
                    [self.content addSubview:line];
                }
            }
            
            i++;
            
        }
        
        // Bottom & top lines (if in a scrollView)
        if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 290, 1)];
            lineTop.backgroundColor = self.lineColor;
            [_scrollView addSubview:lineTop];
            
            UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.contentSize.height, 290, 1)];
            lineBottom.backgroundColor = self.lineColor;
            [_scrollView addSubview:lineBottom];
        }
        
        // Cancel Button
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([otherButtonTitles count] > 4) {
            cancel.frame = CGRectMake(15, (CV_BUTTON_COUNT_MAX * (CV_BUTTON_HEIGHT + 1)) + 7.5f, 290, CV_BUTTON_HEIGHT);
        } else {
            cancel.frame = CGRectMake(15, (i * (CV_BUTTON_HEIGHT + 1)) + 7.5f, 290, CV_BUTTON_HEIGHT);
        }
        [cancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancel setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
        cancel.titleLabel.font = self.buttonFont;
        cancel.backgroundColor = self.cancelBackgroundColor;
        [cancel addTarget:_actionSheet action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancel addTarget:_actionSheet action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [cancel addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
        [cancel addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
        cancel.tag = 1;
        [self.content addSubview:cancel];
        
        // Set Frame
        CGRect frame = self.content.frame;
        frame.size.height = cancel.frame.origin.y + cancel.frame.size.height;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.content.frame = frame;
        [_window addSubview:self.content];
    
    }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        self.content.alpha = 1.0;
        self.background.alpha = 1.0f;
        
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        
        CGRect frame = self.content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height - self.content.frame.size.height - 15;
        self.content.frame = frame;
        
    } completion:nil];
}

#pragma mark - Buttons
#pragma mark Actions

- (void)close:(id)sender
{
    int index = (int)((UIControl*)sender).tag - 2;
    
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        self.background.alpha = 0.0;
        
        CGRect frame = self.content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.content.frame = frame;
        
    } completion:^(BOOL finish){
        
        [self.delegate actionSheetButtonClicked:self.actionSheet
                                withButtonIndex:[NSNumber numberWithInt:index]
                                withButtonTitle:[self.otherButtonTitles objectAtIndex:index]];
        
    }];
}

- (void)cancel:(id)sender
{
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
    
        self.background.alpha = 0.0;
        
        CGRect frame = self.content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        self.content.frame = frame;
    
    } completion:^(BOOL finish){
        
        [self.delegate actionSheetCancelled:self.actionSheet];
        
    }];
}

#pragma mark Highlighting

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (UIView *subview in self.scrollView.subviews) {
        
        if (subview.tag == 0) continue;
        [self buttonRelease:subview];
    }
}

- (void)buttonPress:(id)sender
{
    int tag = (int)((UIControl*)sender).tag;
    UIButton *button = (UIButton*)[self.content viewWithTag:tag];
    
    if (tag == 1) {
        [button setTitleColor:self.selectedCancelTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.selectedCancelBackgroundColor];
    } else {
        [button setTitleColor:self.selectedButtonTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.selectedButtonBackgroundColor];
    }
}

- (void)buttonRelease:(id)sender
{
    int tag = (int)((UIControl*)sender).tag;
    UIButton *button = (UIButton*)[self.content viewWithTag:tag];
    
    if (tag == 1) {
        [button setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.cancelBackgroundColor];
    } else {
        [button setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.buttonBackgroundColor];
    }
}

@end
