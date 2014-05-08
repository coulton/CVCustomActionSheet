//
//  CVCustomActionSheet.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CV_BUTTON_COUNT_MAX 5
#define CV_BUTTON_HEIGHT 44
#define CV_BUTTON_BG [UIColor whiteColor]
#define CV_BUTTON_TEXT [UIColor blackColor]
#define CV_BUTTON_BG_HIGHLIGHT [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0]
#define CV_BUTTON_TEXT_HIGHLIGHT [UIColor blackColor]

#define CV_CANCEL_BG [UIColor colorWithRed:(88.0/255.0) green:(195.0/255.0) blue:(180.0/255.0) alpha:1.0]
#define CV_CANCEL_TEXT [UIColor whiteColor]
#define CV_CANCEL_BG_HIGHLIGHT [UIColor colorWithRed:(88.0/255.0) green:(195.0/255.0) blue:(180.0/255.0) alpha:1.0]
#define CV_CANCEL_TEXT_HIGHLIGHT [UIColor whiteColor]

#define CV_LINE_COLOR [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0]

@class CVCustomActionSheet;
@protocol CVCustomActionSheetDelegate

- (void)actionSheetCancelled:(CVCustomActionSheet*)actionSheet;
- (void)actionSheetButtonClicked:(CVCustomActionSheet*)actionSheet withButtonIndex:(NSNumber*)buttonIndex withButtonTitle:(NSString*)buttonTite;

@end

@interface CVCustomActionSheet : NSObject <UIScrollViewDelegate>

- (id)initWithDelegate:(id<CVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
- (void)show;

@property (nonatomic, retain) id <CVCustomActionSheetDelegate> delegate;
@property (nonatomic, retain) UIView *content;
@property (nonatomic, retain) UIButton *background;
@property (nonatomic, retain) NSNumber *tag;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *otherButtonTitles;
@property (nonatomic, strong) CVCustomActionSheet *actionSheet;

@end
