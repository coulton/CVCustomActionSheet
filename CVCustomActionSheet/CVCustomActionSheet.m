//
//  CVCustomActionSheet.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import "CVCustomActionSheet.h"
#import "UIImage+ImageEffects.h"

@implementation CVCustomActionSheet

- (id)init {
    self = [super init];
    if (self) { }
    return self;
}

- (id)initWithDelegate:(id<CVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _window = [UIApplication sharedApplication].keyWindow;
        _otherButtonTitles = otherButtonTitles;
        _actionSheet = self;
        
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
        
        _content = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        int i = 0;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, 290, CV_BUTTON_HEIGHT * CV_BUTTON_COUNT_MAX)];
        _scrollView.backgroundColor = CV_BUTTON_BG;
        _scrollView.delegate = _actionSheet;
        _scrollView.showsVerticalScrollIndicator = NO;
        if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
            _scrollView.contentSize = CGSizeMake(290, ((CV_BUTTON_HEIGHT + 1) * [otherButtonTitles count]) - 1);
            [_content addSubview:_scrollView];
        }
        
        for (NSString *string in otherButtonTitles) {
            
            UIButton *option = [UIButton buttonWithType:UIButtonTypeCustom];
            option.frame = CGRectMake(15, i * (CV_BUTTON_HEIGHT + 1), 290, CV_BUTTON_HEIGHT);
            [option setTitle:string forState:UIControlStateNormal];
            [option setTitleColor:CV_BUTTON_TEXT forState:UIControlStateNormal];
            option.titleLabel.font = CV_BUTTON_FONT;
            option.backgroundColor = CV_BUTTON_BG;
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
                [_content addSubview:option];
                
            }
            
            // Add a line, if it's not the last entry
            if (i + 1 < [otherButtonTitles count]) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, option.frame.origin.y + CV_BUTTON_HEIGHT, 290, 1)];
                line.backgroundColor = CV_LINE_COLOR;
                
                if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
                    line.frame = CGRectMake(0, option.frame.origin.y + CV_BUTTON_HEIGHT, 290, 1);
                    [_scrollView addSubview:line];
                } else {
                    [_content addSubview:line];
                }
            }
            
            i++;
            
        }
        
        // Bottom & top lines (if in a scrollView)
        if ([otherButtonTitles count] > CV_BUTTON_COUNT_MAX) {
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 290, 1)];
            lineTop.backgroundColor = CV_LINE_COLOR;
            [_scrollView addSubview:lineTop];
            
            UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.contentSize.height, 290, 1)];
            lineBottom.backgroundColor = CV_LINE_COLOR;
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
        [cancel setTitleColor:CV_CANCEL_TEXT forState:UIControlStateNormal];
        cancel.titleLabel.font = CV_BUTTON_FONT;
        cancel.backgroundColor = CV_CANCEL_BG;
        [cancel addTarget:_actionSheet action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancel addTarget:_actionSheet action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [cancel addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
        [cancel addTarget:_actionSheet action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
        cancel.tag = 1;
        [_content addSubview:cancel];
        
        // Set Frame
        CGRect frame = _content.frame;
        frame.size.height = cancel.frame.origin.y + cancel.frame.size.height;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        _content.frame = frame;
        [_window addSubview:_content];
    
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        _content.alpha = 1.0;
        _background.alpha = 1.0f;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        
        CGRect frame = _content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height - _content.frame.size.height - 15;
        _content.frame = frame;
    } completion:nil];
}

#pragma mark - Buttons
#pragma mark Actions

- (void)close:(id)sender {
    int index = (int)((UIControl*)sender).tag - 2;
    
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        
        _background.alpha = 0.0;
        
        CGRect frame = _content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        _content.frame = frame;
        
    } completion:^(BOOL finish){
        
        [_delegate actionSheetButtonClicked:_actionSheet withButtonIndex:[NSNumber numberWithInt:index] withButtonTitle:[_otherButtonTitles objectAtIndex:index]];
        
    }];
}

- (void)cancel:(id)sender {
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
    
        _background.alpha = 0.0;
        
        CGRect frame = _content.frame;
        frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
        _content.frame = frame;
    
    } completion:^(BOOL finish){
        
        [_delegate actionSheetCancelled:_actionSheet];
        
    }];
}

#pragma mark Highlighting

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (UIView *subview in _scrollView.subviews) {
        if (subview.tag > 0) {
            [self buttonRelease:subview];
        }
    }
}

- (void)buttonPress:(id)sender {
    int tag = (int)((UIControl*)sender).tag;
    UIButton *button = (UIButton*)[_content viewWithTag:tag];
    
    if (tag == 1) {
        [button setTitleColor:CV_CANCEL_TEXT_HIGHLIGHT forState:UIControlStateNormal];
        [button setBackgroundColor:CV_CANCEL_BG_HIGHLIGHT];
    } else {
        [button setTitleColor:CV_BUTTON_TEXT_HIGHLIGHT forState:UIControlStateNormal];
        [button setBackgroundColor:CV_BUTTON_BG_HIGHLIGHT];
    }
}

- (void)buttonRelease:(id)sender {
    int tag = (int)((UIControl*)sender).tag;
    UIButton *button = (UIButton*)[_content viewWithTag:tag];
    
    if (tag == 1) {
        [button setTitleColor:CV_CANCEL_TEXT forState:UIControlStateNormal];
        [button setBackgroundColor:CV_CANCEL_BG];
    } else {
        [button setTitleColor:CV_BUTTON_TEXT forState:UIControlStateNormal];
        [button setBackgroundColor:CV_BUTTON_BG];
    }
}

@end
