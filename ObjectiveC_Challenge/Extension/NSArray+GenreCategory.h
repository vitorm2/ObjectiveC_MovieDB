//
//  NSArray+GenreCategory.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 18/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (GenreCategory)


// NSArray "extension" to return genre full String
- (NSString *) getStringWithCommas: (NSString *) dicKey;

@end

NS_ASSUME_NONNULL_END
