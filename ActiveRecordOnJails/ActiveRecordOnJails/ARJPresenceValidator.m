//
//  ARJPresenceValidator.m
//  ActiveRecordOnJails
//
//  Created by skonb on 2013/06/24.
//  Copyright (c) 2013年 skonb. All rights reserved.
//

#import "ARJPresenceValidator.h"
#import "ARJActiveRecord.h"
@implementation ARJPresenceValidator

-(NSArray*)validateValue:(id)value{
    if (value==nil || value == [NSNull null]) {
        return @[@"Presence Error"];
    }else{
        return nil;
    }
}

@end
