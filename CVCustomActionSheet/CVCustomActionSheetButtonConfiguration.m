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
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) UIFont *font;

@end

@implementation CVCustomActionSheetButtonConfiguration

- (instancetype)initWithTextColor:(UIColor *)textColor
                  backgroundColor:(UIColor *)backgroundColor
                   separatorColor:(UIColor *)separatorColor
                             font:(UIFont *)font
{
    self = [super init];
    if (self) {
        NSParameterAssert(textColor);
        NSParameterAssert(backgroundColor);
        NSParameterAssert(separatorColor);
        NSParameterAssert(font);
        
        _textColor = textColor;
        _backgroundColor = backgroundColor;
        _font = font;
        _separatorColor = separatorColor;
    }
    
    return self;
}

+ (CVCustomActionSheetButtonConfiguration *)defaultConfigurationForType:(CVCustomActionType)type
                                                               selected:(BOOL)selected
{
    NSParameterAssert(type);
    
    switch (type) {
        case CVCustomActionTypeDefault:
            return [[CVCustomActionSheetButtonConfiguration alloc] initWithTextColor:[UIColor blackColor]
                                                                     backgroundColor:[UIColor colorWithWhite:selected ? 0.9 : 1.0 alpha:1.0]
                                                                      separatorColor:[UIColor blackColor]
                                                                                font:[UIFont systemFontOfSize:15]];
        case CVCustomActionTypeCancel:
            return [[CVCustomActionSheetButtonConfiguration alloc] initWithTextColor:[UIColor whiteColor]
                                                                     backgroundColor:[UIColor colorWithWhite:selected ? 0.0 : 0.1 alpha:1.0]
                                                                      separatorColor:[UIColor whiteColor]
                                                                                font:[UIFont systemFontOfSize:15]];
    }
}

@end
