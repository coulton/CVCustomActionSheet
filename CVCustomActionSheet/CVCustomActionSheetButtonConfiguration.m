//
//  CVCustomActionSheetButtonConfiguration.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

#import "CVCustomActionSheetButtonConfiguration.h"

@interface CVCustomActionSheetButtonConfiguration ()

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIFont *font;

@end

@implementation CVCustomActionSheetButtonConfiguration

+ (instancetype)configurationWithTextColor:(UIColor *)textColor
                           backgroundColor:(UIColor *)backgroundColor
                                      font:(UIFont *)font
{
    NSParameterAssert(textColor);
    NSParameterAssert(backgroundColor);
    NSParameterAssert(font);
    
    CVCustomActionSheetButtonConfiguration *config = [[CVCustomActionSheetButtonConfiguration alloc] init];
    
    config.textColor = textColor;
    config.backgroundColor = backgroundColor;
    config.font = font;
    
    return config;
}

+ (CVCustomActionSheetButtonConfiguration *)defaultConfigurationForType:(CVCustomActionType)type
                                                               selected:(BOOL)selected
{
    NSParameterAssert(type);
    
    switch (type) {
        case CVCustomActionTypeDefault:
            return [CVCustomActionSheetButtonConfiguration configurationWithTextColor:[UIColor blackColor]
                                                                      backgroundColor:[UIColor colorWithWhite:selected ? 0.9 : 1.0 alpha:1.0]
                                                                                 font:[UIFont systemFontOfSize:15]];
        case CVCustomActionTypeCancel:
            return [CVCustomActionSheetButtonConfiguration configurationWithTextColor:[UIColor whiteColor]
                                                                      backgroundColor:[UIColor colorWithWhite:selected ? 0.0 : 0.1 alpha:1.0]
                                                                                 font:[UIFont systemFontOfSize:15]];
    }
}

@end
