//
//  CVCustomAction.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

@import Foundation;

/**
 *  Holds the properties and handlers for items in a CVCustomActionSheet.
 */
@interface CVCustomAction : NSObject

/**
 *  The style for the button.
 */
typedef enum {
    CVCustomActionTypeDefault = 1,
    CVCustomActionTypeCancel = 2
} CVCustomActionType;

/**
 *  Handler for when the an item is selected.
 *
 *  @param action The action tapped.
 */
typedef void (^CVCustomActionHandler)(CVCustomAction *action);

/**
 *  Creates an action object.
 *
 *  @param title                 (Required) The displayble title.
 *  @param type                  (Required) The style for the button.
 *  @param handler               (Required) The block that gets called when the action is tapped.
 *
 *  @return A CVCustomAction to add to the action sheet.
 */
+ (CVCustomAction *)actionWithTitle:(NSString *)title
                               type:(CVCustomActionType)type
                            handler:(CVCustomActionHandler)handler;

/**
 *  The displayable title.
 */
@property (nonatomic, readonly) NSString *title;

/**
 *  The handler block.
 */
@property (nonatomic, readonly) CVCustomActionHandler handler;

/**
 *  The button type.
 */
@property (nonatomic, readonly) CVCustomActionType type;

@end
