//
//  CVCustomActionSheet.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVCustomActionSheet : NSObject <UIScrollViewDelegate>

- (id)initWithButtons:(NSArray *)buttons andCancelButtonTitle:(NSString*)cancelButtonTitle;
- (void)show;

// Properties
@property (nonatomic, assign) NSInteger *tag;
@property (nonatomic, strong) UIColor *buttonBackgroundColor, *selectedButtonBackgroundColor, *buttonTextColor, *selectedButtonTextColor, *cancelBackgroundColor, *selectedCancelBackgroundColor, *cancelTextColor, *selectedCancelTextColor, *lineColor;
@property (nonatomic, strong) UIFont *buttonFont;

@end
