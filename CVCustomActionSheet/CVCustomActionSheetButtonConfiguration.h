//
//  CVCustomActionSheetButtonConfiguration.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

@import Foundation;
#import "CVCustomAction.h"

/**
 *  Configuration object for CVCustomAction.
 */
@interface CVCustomActionSheetButtonConfiguration : NSObject

/**
 *  Initizer for a configuration object.
 *
 *  @param textColor       The desired text color.
 *  @param backgroundColor The background color for the button.
 *  @param font            The font.
 *
 *  @return A configuration object ready to pass on to a CVCustomAction.
 */
+ (instancetype)configurationWithTextColor:(UIColor *)textColor
                           backgroundColor:(UIColor *)backgroundColor
                                      font:(UIFont *)font;

/**
 *  The default configuration to use when one isn't provided.
 *
 *  @param type     The type of action.
 *  @param selected Selected state?
 *
 *  @return A config object.
 */
+ (CVCustomActionSheetButtonConfiguration *)defaultConfigurationForType:(CVCustomActionType)type
                                                               selected:(BOOL)selected;

/**
 *  The text color for the button.
 */
@property (nonatomic, readonly) UIColor *textColor;

/**
 *  The background color for the button.
 */
@property (nonatomic, readonly) UIColor *backgroundColor;

/**
 *  The font for the button.
 */
@property (nonatomic, readonly) UIFont *font;

@end
