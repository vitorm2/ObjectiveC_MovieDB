//
//  Result.h
//  ObjectiveC_Challenge
//
//  Created by Guilherme Rangel on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchResult : NSObject

@property NSString *poster_path;
@property BOOL *adult;
@property NSString *overview;
@property NSString *release_date;
@property NSArray *genre_ids;
@property NSInteger movieId;
@property NSString *original_title;
@property NSString *original_language;
@property NSString *title;
@property NSString *backdrop_path;
@property NSNumber *vote_count;
@property NSNumber *popularity;
@property BOOL *video;
@property NSNumber *vote_average;



@end
