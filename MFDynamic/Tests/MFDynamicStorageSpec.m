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
	
	context(@"on-disk storage", ^
	{
		it(@"should store its values on disk and retrieve them without loss", ^
		{
			NSString *tempFile = [NSString stringWithFormat:@"%@/MFDynamicStorageTempFile", NSTemporaryDirectory()];
			
			MFNSCodingImplementer *nsCodingImplementer = [[MFNSCodingImplementer alloc] init];
			[nsCodingImplementer setNumber:2];
			
			// Store some things in our MFDynamicStorage instance
			[storage setStringValue:@"My Value"];
			[storage setIntValue:42];
			[storage setNsCodingImplementer:nsCodingImplementer];
			
			// Archive the file and validate that it succeeded
			BOOL success = [NSKeyedArchiver archiveRootObject:storage toFile:tempFile];
			[[theValue(success) should] beYes];
			
			// Unarchive the file and check values
			MFTestStorage *unarchived = [NSKeyedUnarchiver unarchiveObjectWithFile:tempFile];
			[[[unarchived stringValue] should] equal:@"My Value"];
			[[theValue([unarchived intValue]) should] equal:theValue(42)];
			[[theValue([[unarchived nsCodingImplementer] number]) should] equal:theValue(2)];
		});
	});
});

SPEC_END