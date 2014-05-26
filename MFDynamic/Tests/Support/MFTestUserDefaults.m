//
//  MFTestUserDefaults.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-24.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFTestUserDefaults.h"

@implementation MFTestUserDefaults
{
	NSMutableDictionary *_storage;
}

- (id)init
{
    self = [super init];
    if (self)
	{
		_storage = [NSMutableDictionary dictionary];
	}
    return self;
}

#pragma mark Writing

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [_storage setObject:value forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [_storage setObject:[NSNumber numberWithInteger:value] forKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [_storage setObject:[NSNumber numberWithBool:value] forKey:defaultName];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
    [_storage removeObjectForKey:defaultName];
}

#pragma mark Reading

- (id)objectForKey:(NSString *)defaultName
{
    return [_storage objectForKey:defaultName];
}

- (NSInteger)integerForKey:(NSString *)defaultName
{
    return [[_storage objectForKey:defaultName] integerValue];
}

- (BOOL)boolForKey:(NSString *)defaultName
{
    return [[_storage objectForKey:defaultName] boolValue];
}

#pragma mark Special

- (void)registerDefaults:(NSDictionary *)defaults
{
	[_storage addEntriesFromDictionary:defaults];
}

- (void)synchronize
{
	// Do nothing, makes no sense in testing context
}

@end