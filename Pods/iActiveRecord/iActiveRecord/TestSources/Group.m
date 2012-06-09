//
//  Group.m
//  iActiveRecord
//
//  Created by Alex Denisov on 10.01.12.
//  Copyright (c) 2012 CoreInvader. All rights reserved.
//

#import "Group.h"

@implementation Group

@synthesize title;

has_many_imp(User, users, ARDependencyDestroy)
has_many_through_imp(Project, ProjectGroupRelationship, groups, ARDependencyNullify)

validation_do(
    validate_uniqueness_of(title)
)

@end
