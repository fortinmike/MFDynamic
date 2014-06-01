//
//  MFDynamicDefaultsSpec.m
//  MFDynamic
//
//  Created by Michaël Fortin on 2013-08-22.
//  Copyright (c) 2013 Michaël Fortin. All rights reserved.
//

#import <Kiwi.h>
#import "MFDynamicDefaults.h"
#import "MFTestDefaults.h"
#import "MFTestUserDefaults.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

SPEC_BEGIN(MFDynamicDefaultsSpec)

describe(@"MFDynamicDefaults", ^
{
	__block MFTestDefaults *testDefaults;
	
	beforeEach(^
	{
		testDefaults = [[MFTestDefaults alloc] init];
		
		// We're going to use an empty user defaults instance for each test
		testDefaults->_userDefaults = (NSUserDefaults *)[[MFTestUserDefaults alloc] init];
	});
	
	context(@"shared instance", ^
	{
		it(@"should return an instance of the MFDynamicDefaults subclass", ^
		{
			id instance = [MFTestDefaults sharedDefaults];
			
			[[instance should] beKindOfClass:[MFTestDefaults class]];
		});
	});
	
	context(@"defaults registration", ^
	{
		it(@"should register user defaults properly", ^
		{
			NSDate *date = [NSDate date];
			NSArray *array = @[@"A", @"B"];
			[testDefaults registerDefaults:@{@"BoolValue" : @(YES), @"DateValue" : date, @"ArrayValue" : array}];
			[[theValue([testDefaults boolValue]) should] beYes];
			[[theValue([[testDefaults dateValue] compare:date] == NSOrderedSame) should] beYes];
			[[[testDefaults arrayValue] should] equal:array];
		});
	});
	
	context(@"values", ^
	{
		it(@"should store and retrieve NSUserDefaults-supported instances properly", ^
		{
			// NSUserDefaults supports NSData, NSString, NSNumber, NSDate, NSArray and NSDictionary
			// https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/Reference/Reference.html
			
			NSData *data = [@"Data" dataUsingEncoding:NSUTF8StringEncoding];
			[testDefaults setDataValue:data];
			[[[testDefaults dataValue] should] equal:data];
			
			NSString *string = @"String";
			[testDefaults setStringValue:string];
			[[[testDefaults stringValue] should] equal:string];
			
			NSNumber *number = @(1023.3551);
			[testDefaults setNumberValue:number];
			[[[testDefaults numberValue] should] equal:number];
			
			NSDate *date = [NSDate date];
			[testDefaults setDateValue:date];
			[[[testDefaults dateValue] should] equal:date];
			
			NSArray *array = @[@"A", @"B", @"C"];
			[testDefaults setArrayValue:array];
			[[[testDefaults arrayValue] should] equal:array];
			
			NSDictionary *dictionary = @{@"A" : @"B", @"C" : @"D"};
			[testDefaults setDictionaryValue:dictionary];
			[[[testDefaults dictionaryValue] should] equal:dictionary];
		});
		
		it(@"should support nil values", ^
		{
			[testDefaults setDateValue:[NSDate date]];
			[testDefaults setStringValue:@"All work and no play makes Jack a dull boy"];
			
			[[theBlock(^{ [testDefaults setDateValue:nil]; }) shouldNot] raise];
			[[theBlock(^{ [testDefaults setStringValue:nil]; }) shouldNot] raise];
			
			[[[testDefaults dateValue] should] beNil];
			[[[testDefaults stringValue] should] beNil];
		});
	});
});

SPEC_END