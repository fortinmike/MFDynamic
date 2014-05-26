//
//  MFDynamicStorageSpec.m
//  Obsidian
//
//  Created by Michaël Fortin on 11/30/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "MFTestStorage.h"
#import "FileManagement.h"

SPEC_BEGIN(MFDynamicStorageSpec)

describe(@"MFDynamicStorage", ^
{
	__block MFTestStorage *storage;
	
	beforeEach(^
	{
		storage = [[MFTestStorage alloc] init];
	});
	
	context(@"in-memory storage", ^
	{
		it(@"should store and retrieve NSDictionary-compatible objects", ^
		{
			[storage setString:@"Blah"];
			
			[[[storage string] should] equal:@"Blah"];
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
			[storage setInteger:42];
			
			[[theValue([storage integer]) should] equal:theValue(42)];
		});
	});
	
	context(@"on-disk storage", ^
	{
		MFFile *file = [[MFDirectory temp] file:@"dynamic-storage-archive"];
		
		it(@"should store its values on disk and retrieve them without alterations", ^
		{
			MFNSCodingImplementer *nsCodingImplementer = [[MFNSCodingImplementer alloc] init];
			[nsCodingImplementer setNumber:2];
			
			// Store some things in our MFDynamicStorage instance
			[storage setString:@"My Value"];
			[storage setInteger:42];
			[storage setNsCodingImplementer:nsCodingImplementer];
			
			// Archive the file and validate that it succeeded
			BOOL success = [file archive:storage overwrite:YES];
			[[theValue(success) should] beYes];
			
			// Unarchive the file and check values
			MFTestStorage *unarchived = [file unarchive];
			[[[unarchived string] should] equal:@"My Value"];
			[[theValue([unarchived integer]) should] equal:theValue(42)];
			[[theValue([[unarchived nsCodingImplementer] number]) should] equal:theValue(2)];
		});
	});
});

SPEC_END