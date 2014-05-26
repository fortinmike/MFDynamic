//
//  MFDynamicStorageSpec.m
//  MFDynamic
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "MFTestStorage.h"

SPEC_BEGIN(MFDynamicStorageSpec)

describe(@"MFDynamicStorage", ^
{
	__block MFTestStorage *storage;
	
	beforeEach(^
	{
		storage = [[MFTestStorage alloc] init];
	});
	
	context(@"using accessors", ^
	{
		it(@"should store and retrieve BOOL (signed char) without loss", ^
		{
			[storage setBoolValue:YES];
			[[theValue([storage boolValue]) should] beYes];
		});
		   
		it(@"should store and retrieve int without loss", ^
		{
			[storage setIntValue:INT_MIN];
			[[theValue([storage intValue]) should] equal:theValue(INT_MIN)];
			[storage setIntValue:INT_MAX];
			[[theValue([storage intValue]) should] equal:theValue(INT_MAX)];
		});
		
		it(@"should store and retrieve short without loss", ^
		{
			[storage setShortValue:SHRT_MIN];
			[[theValue([storage shortValue]) should] equal:theValue(SHRT_MIN)];
			[storage setShortValue:SHRT_MAX];
			[[theValue([storage shortValue]) should] equal:theValue(SHRT_MAX)];
		});
		
		it(@"should store and retrieve long without loss", ^
		{
			[storage setLongValue:LONG_MIN];
			[[theValue([storage longValue]) should] equal:theValue(LONG_MIN)];
			[storage setLongValue:LONG_MAX];
			[[theValue([storage longValue]) should] equal:theValue(LONG_MAX)];
		});
		
		it(@"should store and retrieve long long without loss", ^
		{
			[storage setLongLongValue:LLONG_MIN];
			[[theValue([storage longLongValue]) should] equal:theValue(LLONG_MIN)];
			[storage setLongLongValue:LLONG_MAX];
			[[theValue([storage longLongValue]) should] equal:theValue(LLONG_MAX)];
		});
		
		it(@"should store and retrieve unsigned char without loss", ^
		{
			[storage setUnsignedCharValue:UCHAR_MAX];
			[[theValue([storage unsignedCharValue]) should] equal:theValue(UCHAR_MAX)];
		});
		
		it(@"should store and retrieve unsigned int without loss", ^
		{
			[storage setUnsignedIntValue:UINT_MAX];
			[[theValue([storage unsignedIntValue]) should] equal:theValue(UINT_MAX)];
		});
		
		it(@"should store and retrieve unsigned short without loss", ^
		{
			[storage setUnsignedShortValue:USHRT_MAX];
			[[theValue([storage unsignedShortValue]) should] equal:theValue(USHRT_MAX)];
		});
		
		it(@"should store and retrieve unsigned long without loss", ^
		{
			[storage setUnsignedLongValue:ULONG_MAX];
			[[theValue([storage unsignedLongValue]) should] equal:theValue(ULONG_MAX)];
		});
		
		it(@"should store and retrieve unsigned long long without loss", ^
		{
			[storage setUnsignedLongLongValue:ULLONG_MAX];
			[[theValue([storage unsignedLongLongValue]) should] equal:theValue(ULLONG_MAX)];
		});
		
		it(@"should store and retrieve float without loss", ^
		{
			[storage setFloatValue:FLT_MIN];
			[[theValue([storage floatValue]) should] equal:FLT_MIN withDelta:FLT_EPSILON];
			[storage setFloatValue:FLT_MAX];
			[[theValue([storage floatValue]) should] equal:FLT_MAX withDelta:FLT_EPSILON];
		});
		
		it(@"should store and retrieve double without loss", ^
		{
			[storage setDoubleValue:DBL_MIN];
			[[theValue([storage doubleValue]) should] equal:DBL_MIN withDelta:FLT_EPSILON];
			[storage setDoubleValue:DBL_MAX];
			[[theValue([storage doubleValue]) should] equal:DBL_MAX withDelta:FLT_EPSILON];
		});
	});
	
	context(@"in-memory storage", ^
	{
		it(@"should store and retrieve NSDictionary-compatible objects", ^
		{
			[storage setStringValue:@"Blah"];
			
			[[[storage stringValue] should] equal:@"Blah"];
		});
		
		it(@"should store and retrieve NSCoding-implementing objects", ^
		{
			MFNSCodingImplementer *original = [[MFNSCodingImplementer alloc] init];
			[original setNumber:42];
			[storage setNsCodingImplementer:original];
			
			[[theValue([[storage nsCodingImplementer] number]) should] equal:theValue(42)];
		});
		
		it(@"should store scalar values", ^
		{
			[storage setIntValue:42];
			
			[[theValue([storage intValue]) should] equal:theValue(42)];
		});
	});
	
	context(@"on-disk storage", ^
	{
		it(@"should store its values on disk and retrieve them without loss", ^
		{
			MFNSCodingImplementer *nsCodingImplementer = [[MFNSCodingImplementer alloc] init];
			[nsCodingImplementer setNumber:2];
			
			// Store some things in our MFDynamicStorage instance
			[storage setStringValue:@"My Value"];
			[storage setIntValue:42];
			[storage setNsCodingImplementer:nsCodingImplementer];
			
			// TODO:
			
			// Archive the file and validate that it succeeded
//			BOOL success = [NSKeyedArchiver archiveRootObject:storage toFile:file];
//			[[theValue(success) should] beYes];
			
			// Unarchive the file and check values
//			MFTestStorage *unarchived = [file unarchive];
//			[[[unarchived string] should] equal:@"My Value"];
//			[[theValue([unarchived integer]) should] equal:theValue(42)];
//			[[theValue([[unarchived nsCodingImplementer] number]) should] equal:theValue(2)];
		});
	});
});

SPEC_END