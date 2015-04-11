//
//  CVCustomActionSheet.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 5/7/14.
//  Copyright (c) 2014 twobros. All rights reserved.
//

@import Foundation;
#import "CVCustomAction.h"
@class CVCustomAction;
@class CVCustomActionSheetButtonConfiguration;

/**
 *  A customizable action sheet.
 */
@interface CVCustomActionSheet : NSObject

/**
 *  Sets configuration for a button.
 *
 *  @param buttonConfiguration The button configuration. (Required)
 *  @param type                The action type.
 *  @param selected            Is this the selected state?
 */
- (void)setButtonConfiguration:(CVCustomActionSheetButtonConfiguration *)buttonConfiguration
                       forType:(CVCustomActionType)type
                      selected:(BOOL)selected;

/**
 *  This will get called when the action sheet is finished dismissing.
 */
@property (nonatomic, copy) void (^dismissBlock)();

/**
 *  Add an action to the action sheet. A cancel button and at least 1 default button is required.
 *
 *  @param action The action to add.
 */
- (void)addAction:(CVCustomAction *)action;

/**
 *  Show the action sheet.
 */
- (void)show;

/**
 *  Manually dismiss the action sheet.
 */
- (void)dismiss;

@end
