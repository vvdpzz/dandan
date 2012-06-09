//
//  Animal.h
//  iActiveRecord
//
//  Created by Alex Denisov on 31.03.12.
//  Copyright (c) 2012 CoreInvader. All rights reserved.
//

#import "ActiveRecord.h"

@interface Animal : ActiveRecord
    <ARValidatableProtocol>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *state;

@end
