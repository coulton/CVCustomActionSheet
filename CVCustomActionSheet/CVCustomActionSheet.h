//
//  CVCustomActionSheet.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CVOptionPressed)(NSInteger buttonIndex, NSString *buttonTitle);
typedef void (^CVCancelPressed)();

@interface CVCustomActionSheet : NSObject <UIScrollViewDelegate>

- (id)initWithOptions:(NSArray *)options andCancelButtonTitle:(NSString*)cancelButtonTitle;
- (void)show:(CVCancelPressed)cancelBlock optionPressed:(CVOptionPressed)optionBlock;

@property (nonatomic, assign) NSInteger *tag;
@property (nonatomic, strong) UIColor *buttonBackgroundColor, *selectedButtonBackgroundColor, *buttonTextColor, *selectedButtonTextColor, *cancelBackgroundColor, *selectedCancelBackgroundColor, *cancelTextColor, *selectedCancelTextColor, *lineColor;
@property (nonatomic, strong) UIFont *buttonFont;

@end
