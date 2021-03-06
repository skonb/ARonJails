//
//  ARJSQLInsertInvocation.m
//  ActiveRecord on Jails
//
//  Created by skonb on 2013/06/24.
//  Copyright (c) 2013年 skonb. All rights reserved.
//

#import "ARJSQLInsertInvocation.h"
#import "ARJDatabaseManager.h"
@implementation ARJSQLInsertInvocation

-(id)invokeInDatabaseManager:(ARJDatabaseManager *)manager{
    __block id res = nil;
    [manager runInTransaction:^BOOL(id database) {
        BOOL result = [database executeUpdate:self.SQLString withArgumentsInArray:self.parameters];
        res = @(result);
        return result;
    }];
    return res;
}

@end
