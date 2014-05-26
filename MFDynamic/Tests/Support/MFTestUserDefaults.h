//
//  MFTestUserDefaults.h
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-24.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//
//  Inspired by zoul/TestingUserDefaults:
//  https://github.com/zoul/TestingUserDefaults/blob/master/CCTestingUserDefaults.m
//

#import <Foundation/Foundation.h>

@interface MFTestUserDefaults : NSObject

#pragma mark Writing

- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;

#pragma mark Reading

- (id)objectForKey:(NSString *)defaultName;
- (NSInteger)integerForKey:(NSString *) defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;

#pragma mark Special

- (void)registerDefaults:(NSDictionary *)defaults;
- (void)synchronize;

@end