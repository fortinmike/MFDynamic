//
//  MFDynamicStorage.h
//  MFDynamic
//
//  Created by Michaël Fortin on 11/29/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFDynamicBase.h"

@interface MFDynamicStorage : MFDynamicBase<NSCoding>

/**
 *  Creates a new instance of your MFDynamicStorage subclass by loading it from a file.
 *
 *  @param file The path to the file to load.
 *
 *  @return A new instance of your MFDynamicStorage subclass with all of its @dynamic properties set to the loaded values.
 */
+ (instancetype)loadFromFile:(NSString *)file;

/**
 *  Saves all @dynamic properties into a file.
 *
 *  @param file The file to write to.
 *
 *  @return Whether the operation succeeded or not.
 */
- (BOOL)saveToFile:(NSString *)file;

@end