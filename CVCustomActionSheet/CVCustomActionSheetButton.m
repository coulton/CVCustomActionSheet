//
//  CVCustomActionSheetButton.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

#import "CVCustomActionSheetButton.h"
#import "CVCustomActionSheetButtonConfiguration.h"

@interface CVCustomActionSheetButton ()

@property (nonatomic) CVCustomAction *action;
@property (nonatomic) CVCustomActionSheetButtonConfiguration *defaultConfiguration;
@property (nonatomic) CVCustomActionSheetButtonConfiguration *selectedConfiguration;

@end

@implementation CVCustomActionSheetButton

- (instancetype)initWithAction:(CVCustomAction *)action
          defaultConfiguration:(CVCustomActionSheetButtonConfiguration *)defaultConfiguration
         selectedConfiguration:(CVCustomActionSheetButtonConfiguration *)selectedConfiguration
{
    self = [super init];
    if (self) {
        _action = action;
        _defaultConfiguration = defaultConfiguration;
        _selectedConfiguration = selectedConfiguration;
        
        [self setTitle:action.title forState:UIControlStateNormal];
        
        [self setTitleColor:defaultConfiguration.textColor forState:UIControlStateNormal];
        self.titleLabel.font = defaultConfiguration.font;
        self.backgroundColor = defaultConfiguration.backgroundColor;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    CVCustomActionSheetButtonConfiguration *configuration = highlighted ? self.selectedConfiguration : self.defaultConfiguration;
    
    [self setTitleColor:configuration.textColor forState:UIControlStateNormal];
    self.titleLabel.font = configuration.font;
    self.backgroundColor = configuration.backgroundColor;
}

@end
