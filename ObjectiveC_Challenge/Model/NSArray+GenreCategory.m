//
//  NSArray+GenreCategory.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 18/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "NSArray+GenreCategory.h"

@implementation NSArray (GenreCategory)

- (NSString *) getGenreFullString {
    
    
    NSString *genreString = NSString.new;
    NSString *symbol = NSString.new;
    
    
    for (NSDictionary *genreObject in self) {
        NSString *genre = [genreObject objectForKey: @"name"];
        
        
        if (genreObject != self.lastObject) {
            symbol = @", ";
        } else {
            symbol = @"";
        }
        
        genre = [genre stringByAppendingString: symbol];
        genreString = [genreString stringByAppendingString: genre];
    }
    
    return genreString;
}

@end
