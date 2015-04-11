//
//  CVCustomAction.m
//  CVCustomActionSheet
//
//  Created by Coulton Vento on 4/5/15.
//  Copyright (c) 2015 Coulton Vento. All rights reserved.
//

#import "CVCustomAction.h"

@interface CVCustomAction ()

@property (nonatomic) NSString *title;
@property (nonatomic) CVCustomActionHandler handler;
@property (nonatomic) CVCustomActionType type;

@end

@implementation CVCustomAction

+ (CVCustomAction *)actionWithTitle:(NSString *)title
                               type:(CVCustomActionType)type
                            handler:(CVCustomActionHandler)handler
{
    NSParameterAssert(title);
    NSParameterAssert(type);
    
    CVCustomAction *action = [[CVCustomAction alloc] init];
    
    action.title = title;
    action.handler = handler;
    action.type = type;
    
    return action;
}

@end
