//
//  ARJSQLInvocation.m
//  ActiveRecord on Jails
//
//  Created by skonb on 2013/06/24.
//  Copyright (c) 2013年 skonb. All rights reserved.
//

#import "ARJSQLInvocation.h"
#import "ARJSQLSelectInvocation.h"
#import "ARJSQLUpdateInvocation.h"
#import "ARJSQLDeleteInvocation.h"
#import "ARJSQLInsertInvocation.h"
#import "ARJDatabaseManager.h"

NSString * ARJSQLInvocationSQLStringSpecifier = @"ARJSQLInvocationSQLStringSpecifier";
NSString * ARJSQLInvocationSQLParametersSpecifier = @"ARJSQLInvocationSQLParametersSpecifier";
NSString * ARJSQLInvocationTypeSpecifier = @"ARJSQLInvocationTypeSpecifier";

@implementation ARJSQLInvocation
+(ARJSQLInvocation*)SQLInvocationWithDictionary:(NSDictionary*)dictionary{
    ARJSQLInvocation * invocation = nil;
    switch ([dictionary[ARJSQLInvocationTypeSpecifier]integerValue]) {
        case ARJSQLInvocationTypeUpdate:
            invocation = [[ARJSQLUpdateInvocation alloc]initWithDictionary:dictionary];
            break;
        case ARJSQLInvocationTypeInsert:
            invocation = [[ARJSQLInsertInvocation alloc]initWithDictionary:dictionary];
            break;
        case ARJSQLInvocationTypeDelete:
            invocation = [[ARJSQLDeleteInvocation alloc]initWithDictionary:dictionary];
            break;
        case ARJSQLInvocationTypeSelect:
            invocation = [[ARJSQLSelectInvocation alloc]initWithDictionary:dictionary];
            break;
        default:
            break;
    }
    return invocation;
}

-(id)initWithDictionary:(NSDictionary *)dictionary{
    if ([super init]) {
        self.dictionary = dictionary;
    }
    return self;
}

-(id)invokeInDatabaseManager:(ARJDatabaseManager*)manager{
    [self doesNotRecognizeSelector:@selector(invokeInDatabaseManager:)];
    return nil;
}

-(id)invoke{
    return [self invokeInDatabaseManager:[ARJDatabaseManager defaultManager]];
}

-(NSString*)SQLString{
    return self.dictionary[ARJSQLInvocationSQLStringSpecifier];
}

-(NSArray*)parameters{
    return self.dictionary[ARJSQLInvocationSQLParametersSpecifier];
}

@end
