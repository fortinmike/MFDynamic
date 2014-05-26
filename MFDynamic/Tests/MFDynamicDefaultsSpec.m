//
//  MFDynamicDefaultsSpec.m
//  Obsidian
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

#if TARGET_OS_IPHONE
UIImage *testImage()
{
	UIGraphicsBeginImageContext(CGSizeMake(64,64));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextFillRect(context, CGRectMake(0, 0, 64, 64));
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}
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
	
	context(@"when using accessors", ^
	{
		it(@"should have its dynamically-generated setter called", ^
		{
			[[[testDefaults->_userDefaults should] receive] setObject:any() forKey:any()];
			[testDefaults setBoolDefault:YES];
		});
		
		it(@"should have its dynamically-generated getter called", ^
		{
			[[[testDefaults->_userDefaults should] receive] objectForKey:any()];
			[testDefaults boolDefault];
		});
		
		it(@"should store and retrieve NSUserDefaults-supported instances properly", ^
		{
			// NSUserDefaults supports NSData, NSString, NSNumber, NSDate, NSArray and NSDictionary
			// https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/Reference/Reference.html
			
			NSData *data = [@"Data" dataUsingEncoding:NSUTF8StringEncoding];
			[testDefaults setDataDefault:data];
			[[[testDefaults dataDefault] should] equal:data];
			
			NSString *string = @"String";
			[testDefaults setStringDefault:string];
			[[[testDefaults stringDefault] should] equal:string];
			
			NSNumber *number = @(1023.3551);
			[testDefaults setNumberDefault:number];
			[[[testDefaults numberDefault] should] equal:number];
			
			NSDate *date = [NSDate date];
			[testDefaults setDateDefault:date];
			[[[testDefaults dateDefault] should] equal:date];
			
			NSArray *array = @[@"A", @"B", @"C"];
			[testDefaults setArrayDefault:array];
			[[[testDefaults arrayDefault] should] equal:array];
			
			NSDictionary *dictionary = @{@"A" : @"B", @"C" : @"D"};
			[testDefaults setDictionaryDefault:dictionary];
			[[[testDefaults dictionaryDefault] should] equal:dictionary];
		});
		
		it(@"should store and retrieve NSUserDefaults-supported objects if property is of type id", ^
		{
			NSDate *date = [NSDate date];
			[testDefaults setObjectDefault:date];
			[[[testDefaults objectDefault] should] equal:date];
			
			NSString *string = @"String";
			[testDefaults setObjectDefault:string];
			[[[testDefaults objectDefault] should] equal:string];
		});
		
		it(@"should store and retrieve instances that conform to NSCoding", ^
		{
			NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
			[testDefaults setUrlDefault:url];
			[[[testDefaults urlDefault] should] equal:url];
			
#if TARGET_OS_IPHONE
			UIImage *image = testImage();
			[testDefaults setImageDefault:image];
			
			NSData *retrievedImageData = UIImagePNGRepresentation([testDefaults imageDefault]);
			NSData *expectedImageData = UIImagePNGRepresentation(image);
			
			[[retrievedImageData should] equal:expectedImageData];
			
			UIColor *color = [UIColor redColor];
			[testDefaults setColorDefault:color];
			[[[testDefaults colorDefault] should] equal:color];
#endif
		});
		
		it(@"should return value types' default values when nothing exists in user defaults for the accessed value-type property", ^
		{
			[[theValue([testDefaults boolDefault]) should] beNo];
			[[theValue([testDefaults charDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults intDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults shortDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults longDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults longLongDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedCharDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedIntDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedShortDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedLongDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults unsignedLongLongDefault]) should] equal:theValue(0)];
			[[theValue([testDefaults floatDefault]) should] equal:0 withDelta:FLT_EPSILON];
			[[theValue([testDefaults doubleDefault]) should] equal:0 withDelta:DBL_EPSILON];
		});
		
		it(@"should return nil when nothing exists in user defaults for the accessed object property", ^
		{
			[[[testDefaults dataDefault] should] beNil];
			[[[testDefaults stringDefault] should] beNil];
			[[[testDefaults numberDefault] should] beNil];
			[[[testDefaults dateDefault] should] beNil];
			[[[testDefaults arrayDefault] should] beNil];
			[[[testDefaults dictionaryDefault] should] beNil];
			
#if TARGET_OS_IPHONE
			[[[testDefaults imageDefault] should] beNil];
			[[[testDefaults colorDefault] should] beNil];
#endif
			
			[[[testDefaults objectDefault] should] beNil];
		});
	});
	
	context(@"when using defaults registration", ^
	{
		it(@"should register user defaults properly", ^
		{
			NSDate *date = [NSDate date];
			NSArray *array = @[@"A", @"B"];
			[testDefaults registerDefaults:@{@"BoolDefault" : @(YES), @"DateDefault" : date, @"ArrayDefault" : array}];
			[[theValue([testDefaults boolDefault]) should] beYes];
			[[theValue([[testDefaults dateDefault] compare:date] == NSOrderedSame) should] beYes];
			[[[testDefaults arrayDefault] should] equal:array];
		});
	});
});

SPEC_END