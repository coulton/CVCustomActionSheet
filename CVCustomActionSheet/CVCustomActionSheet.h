//
//  CVCustomActionSheet.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CV_BACKGROUND_RADIUS 4
#define CV_BACKGROUND_TINT [UIColor colorWithWhite:0.3 alpha:0.55]

#define CV_BUTTON_COUNT_MAX 5
#define CV_BUTTON_HEIGHT 44

@class CVCustomActionSheet;
@protocol CVCustomActionSheetDelegate

- (void)actionSheetCancelled:(CVCustomActionSheet*)actionSheet;
- (void)actionSheetButtonClicked:(CVCustomActionSheet*)actionSheet withButtonIndex:(NSNumber*)buttonIndex withButtonTitle:(NSString*)buttonTite;

@end

@interface CVCustomActionSheet : NSObject <UIScrollViewDelegate>

- (id)initWithDelegate:(id<CVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
- (void)show;

@property (nonatomic, retain) id <CVCustomActionSheetDelegate> delegate;
@property (nonatomic, strong) CVCustomActionSheet *actionSheet;
@property (nonatomic, assign) NSInteger *tag;
@property (nonatomic, strong) UIColor *buttonBackgroundColor, *selectedButtonBackgroundColor, *buttonTextColor, *selectedButtonTextColor, *cancelBackgroundColor, *selectedCancelBackgroundColor, *cancelTextColor, *selectedCancelTextColor, *lineColor;
@property (nonatomic, strong) UIFont *buttonFont;

@end
