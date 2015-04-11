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
 *  @param separatorColor  The color for the separator;
 *  @param font            The font.
 *
 *  @return A configuration object ready to pass on to a CVCustomAction.
 */
- (instancetype)initWithTextColor:(UIColor *)textColor
                  backgroundColor:(UIColor *)backgroundColor
                   separatorColor:(UIColor *)separatorColor
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

/**
 *  The color of the separators.
 */
@property (nonatomic, readonly) UIColor *separatorColor;

@end
