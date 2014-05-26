//
//  MFHumanReadableConverter.h
//  MFDynamic
//
//  Created by Michaël Fortin on 2014-04-11.
//  Copyright (c) 2014 irradiated.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFHumanReadableConverter : NSObject

+ (id<NSCoding>)convertToHumanReadable:(id)object;
+ (id<NSCoding>)convertFromHumanReadable:(id)object withTargetType:(Class)targetType;

@end