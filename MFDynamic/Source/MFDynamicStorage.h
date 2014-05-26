//
//  MFDynamicStorage.h
//  MFDynamic
//
//  Created by Michaël Fortin on 11/29/2013.
//  Copyright (c) 2013 irradiated.net. All rights reserved.
//

#import "MFDynamicBase.h"

@interface MFDynamicStorage : MFDynamicBase<NSCoding>

- (BOOL)save:(NSString *)file;
- (BOOL)load:(NSString *)file;

@end