//
//  ARJActiveRecord.h
//  ActiveRecordOnJails
//
//  Created by skonb on 2013/06/03.
//  Copyright (c) 2013年 skonb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARJRelation.h"
#import "ARJActiveRecordHelper.h"
#import "ARJModelAttribute.h"
#import "ARJValidationErrors.h"
#import "ARJScope.h"
#import "ARJModelValidator.h"
#import "ARJDatabaseManager.h"

@interface ARJActiveRecord : NSObject
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSDictionary *_columnDictionary;
@property (nonatomic, strong) NSMutableDictionary * _updateDictionary;
@property (nonatomic, readonly) BOOL valid;
@property (nonatomic, strong) ARJValidationErrors *errors;
@property (nonatomic, assign) BOOL changed;
@property (nonatomic, weak) ARJDatabaseManager * correspondingDatabaseManager;
-(id)initWithDictionary:(NSDictionary*)dictionary;
-(id)latestValueForKey:(NSString*)key;
+(ARJActiveRecord*)instanceWithDictionary:(NSDictionary*)dictionary;
+(NSDictionary*)schema;
+(NSString*)model;
+(NSDictionary*)attributes;
+(NSDictionary*)relations;

+(NSDictionary*)validations;
+(NSArray*)scopes;
+(NSString*)tableName;
+(ARJRelation*)relationForKey:(NSString*)key;


/* uses defaultManager */
+(id)find:(NSDictionary*)condition;
+(id)findFirst:(NSDictionary*)condition;
+(NSArray*)findAll;
+(void)destroyAll;
-(BOOL)destroy;
-(BOOL)save;
-(id)update:(NSDictionary*)attributes;
+(id)create:(NSDictionary*)attributes;

/* uses specific manager */
+(id)find:(NSDictionary*)condition inDatabaseManager:(ARJDatabaseManager*)manager;
+(id)findFirst:(NSDictionary*)condition inDatabaseManager:(ARJDatabaseManager*)manager;
+(NSArray*)findAllInDatabaseManager:(ARJDatabaseManager*)manager;
+(void)destroyAllInDatabaseManager:(ARJDatabaseManager*)manager;
-(BOOL)destroyInDatabaseManager:(ARJDatabaseManager*)manager;
-(BOOL)saveInDatabaseManager:(ARJDatabaseManager*)manager;
-(id)update:(NSDictionary*)attributes inDatabaseManager:(ARJDatabaseManager*)manager;
+(id)create:(NSDictionary*)attributes inDatabaseManager:(ARJDatabaseManager*)manager;

+(ARJScope*)scoped;
+(ARJScope*)insertScope;
-(ARJScope*)updateScope;
-(ARJScope*)destroyScope;
-(void)clearRelationCache;
-(id)attributeForKey:(NSString*)key;
-(void)setAttribute:(id)attribute forKey:(NSString *)key;
-(id)associatedForKey:(NSString*)key;
-(void)setAssociated:(id)associated forKey:(NSString*)key;
-(void)insertAssociated:(id)associated forKey:(NSString*)key;


-(BOOL)willDestroy;
-(BOOL)didDestroy;
-(BOOL)willSave;
-(BOOL)didSave;
-(BOOL)willCreate;
-(BOOL)didCreate;
-(BOOL)willValidate;
-(BOOL)didValidate;

-(BOOL)validate;
-(BOOL)validateInDatabaseManager:(ARJDatabaseManager*)manager;
-(BOOL)saveAssociated;

-(void)reload;
@end
