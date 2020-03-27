//
//  NSArray+GenreCategory.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 18/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "NSArray+GenreCategory.h"

@implementation NSArray (GenreCategory)

- (NSString *) getStringWithCommas: (NSString *) dicKey {
    
    NSString *resultString = NSString.new;
    NSString *symbol = @", ";
    
    for (NSDictionary *genreObject in self) {
        NSString *stringValue = [genreObject objectForKey: dicKey];
        
        if (genreObject != self.lastObject) {
             stringValue = [stringValue stringByAppendingString: symbol];
        }
        
        resultString = [resultString stringByAppendingString: stringValue];
    }
    
    return resultString;
}

@end
