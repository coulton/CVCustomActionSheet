//
//  CVCustomActionSheetButton.h
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

@import UIKit;
@class CVCustomAction;
@class CVCustomActionSheetButtonConfiguration;

/**
 *  A styled button.
 */
@interface CVCustomActionSheetButton : UIButton

/**
 *  Initialize a action sheet button.
 *
 *  @param action                The action.
 *  @param defaultConfiguration  The configuration for the normal state.
 *  @param selectedConfiguration The configuration for the selected button.
 *
 *  @return A styled button.
 */
- (instancetype)initWithAction:(CVCustomAction *)action
          defaultConfiguration:(CVCustomActionSheetButtonConfiguration *)defaultConfiguration
         selectedConfiguration:(CVCustomActionSheetButtonConfiguration *)selectedConfiguration;

/**
 *  The action.
 */
@property (nonatomic, readonly) CVCustomAction *action;

@end
