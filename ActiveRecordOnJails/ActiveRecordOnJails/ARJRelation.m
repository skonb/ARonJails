//
//  ARJRelation.m
//  ActiveRecord on Jails
//
//  Created by skonb on 2013/06/17.
//  Copyright (c) 2013年 skonb. All rights reserved.
//

#import "ARJRelation.h"
#import "ARJActiveRecord.h"
#import "ARJActiveRecordHelper.h"
#import "ARJHasManyRelation.h"
#import "ARJBelongsToRelation.h"
#import "ARJHasOneRelation.h"
#import "ARJExpectationHelper.h"
#import "NSString+ActiveSupportInflector.h"
@interface ARJRelation()

@end

@implementation ARJRelation
@synthesize foreignKey = _foreignKey, associationKey = _associationKey, destinationModel = _destinationModel, primaryKey = _primaryKey;
-(id)init{
    if ([super init]) {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}


+(ARJRelation*)relationWithDictionary:(NSDictionary*)dictionary forModel:(Class)klass{
    ARJRelation * relation = nil;
    if ([dictionary[ARJRelationTypeSpecifier]isEqualToString:ARJHasManyRelationSpecifier]) {
        relation = [[ARJHasManyRelation alloc]initWithDictionary:dictionary forModel:klass];
    }else if([dictionary[ARJRelationTypeSpecifier]isEqualToString:ARJHasOneRelationSpecifier]){
        relation = [[ARJHasOneRelation alloc]initWithDictionary:dictionary forModel:klass];
    }else if([dictionary[ARJRelationTypeSpecifier]isEqualToString:ARJBelongsToRelationSpecifier]){
        relation = [[ARJBelongsToRelation alloc]initWithDictionary:dictionary forModel:klass];
    }
    return relation;
}

-(NSString*)foreignKey{
    if(!_foreignKey){
        if (self.dictionary[ARJForeignKeySpecifier]) {
            _foreignKey = self.dictionary[ARJForeignKeySpecifier];
        }else{
            _foreignKey = [[[self.sourceModel tableName]singularizeString] stringByAppendingString:@"Id"];
        }
    }
    return _foreignKey;
}
-(NSString*)primaryKey{
    if (!_primaryKey) {
        if(self.dictionary[ARJPrimaryKeySpecifier]){
            _primaryKey = self.dictionary[ARJPrimaryKeySpecifier];
        }else{
            _primaryKey = @"id";
        }
    }
    return _primaryKey;
}

-(NSString*)associationKey{
    if (!_associationKey) {
        if (self.dictionary[ARJAssociationKeySpecifier]) {
            _associationKey = self.dictionary[ARJAssociationKeySpecifier];
        }else{
            _associationKey = [self.relationName stringByAppendingString:@"Id"];
        }
    }
    return _associationKey;
}

-(id)initWithDictionary:(NSDictionary *)dictionary forModel:(Class)model{
    if ([super init]) {
        self.dictionary = dictionary;
        _sourceModel = model;
    }
    return self;
}

-(BOOL)willDestroySourceInstance:(ARJActiveRecord*)instance{
    [self doesNotRecognizeSelector:@selector(willDestroySourceInstance:)];
    return NO;
}

-(BOOL)willDestroySourceInstance:(ARJActiveRecord *)instance inDatabaseManager:(ARJDatabaseManager *)manager{
    return [self willDestroySourceInstance:instance];
}

-(NSDictionary*)attributes{
    [self doesNotRecognizeSelector:@selector(attributes)];
    return nil;
}

-(NSString*)inverseRelationKey{
    NSString *res = self.dictionary[ARJInverseRelationSpecifier];
    if (!res) {
//        res = [[ARJExpectationHelper defaultHelper]nonCamelizedFromCamelized:[[self sourceModel]model]];
        res = [[self sourceModel]model];
        res = [[[res substringToIndex:1]lowercaseString]stringByAppendingString:[res substringFromIndex:1]];
    }
    return res;
}

-(ARJRelation*)inverseRelation{
    NSDictionary *relations =[self.destinationModel relations];
    ARJRelation * res = relations[[self inverseRelationKey]];
    if (!res) {
        res = relations[[[self inverseRelationKey]pluralizeString]];
    }
    return res;
}

-(BOOL)setDestinationInstance:(id)destination toSourceInstance:(id)source{
    return [self setDestinationInstance:destination toSourceInstance:source inDatabaseManager:[ARJDatabaseManager defaultManager]];
}

-(BOOL)setDestinationInstance:(id)destination toSourceInstance:(id)source inDatabaseManager:(ARJDatabaseManager *)manager{
    [self doesNotRecognizeSelector:@selector(setDestinationInstance:toSourceInstance:inDatabaseManager:)];
    return NO;
}

-(Class)destinationModel{
    if (!_destinationModel) {
        if (self.dictionary[ARJClassNameSpecifier]) {
            _destinationModel = NSClassFromString(self.dictionary[ARJClassNameSpecifier]);
        }
    }
    return _destinationModel;
}

-(id)destinationForSource:(ARJActiveRecord*)source{
    [self destinationForSource:source inDatabaseManager:[ARJDatabaseManager defaultManager]];
    return nil;
}

-(id)destinationForSource:(ARJActiveRecord *)source inDatabaseManager:(ARJDatabaseManager *)manager{
    [self doesNotRecognizeSelector:@selector(destinationForSource:inDatabaseManager:)];
    return nil;
}

-(NSString*)relationName{
    return self.dictionary[ARJRelationNameSpecifier];
}

-(BOOL)autosave{
    return [self.dictionary[ARJAutoSaveSpecifier]boolValue];
}

+(ARJDatabaseManager*)expectedDatabaseManagerForSource:(ARJActiveRecord*)source andDestination:(id)destination{
    ARJDatabaseManager *manager = [destination correspondingDatabaseManager];
    if (!manager) {
        manager = [source correspondingDatabaseManager];
    }
    if (!manager) {
        manager =  [ARJDatabaseManager defaultManager];
    }
    return manager;
}

-(id)blankValue{
    return [NSNull null];
}
-(NSString*)foreignRelationName{
    return self.inverseRelation.relationName;
}

-(void)updateDependency{
    if ([self.dictionary[ARJDependencySpecifier]isEqualToString:ARJDependencyDestroySpecifier]) {
        _dependency = ARJRelationDependencyDestroy;
    }else{
        _dependency = ARJRelationDependencyNullify;
    }
}

-(void)setDictionary:(NSDictionary *)dictionary{
    _dictionary = dictionary;
    [self updateDependency];
}

@end
