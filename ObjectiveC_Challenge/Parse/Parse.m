//
//  Parse.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "Parse.h"
#import "NSArray+GenreCategory.h"

@implementation Parse

static NSString *const imageBaseURL = @"https://image.tmdb.org/t/p/w500";

+ (Movie *)parseMovie:(NSDictionary *)movieDic {
    
    Movie *movieDetails = [[Movie alloc] init];
    
    movieDetails.title = [movieDic objectForKey: @"original_title"];
    movieDetails.overview = [movieDic objectForKey: @"overview"];
    movieDetails.vote_avegare = [movieDic objectForKey:@"vote_average"];
    
    // Image
    NSString *poster_path = [movieDic objectForKey: @"poster_path"];
    movieDetails.imageURL = [imageBaseURL stringByAppendingString: poster_path];
    
    // Genres
    NSArray *genresObjectArray = [movieDic objectForKey: @"genres"];
    movieDetails.genres = [genresObjectArray getStringWithCommas: @"name"];
    
    return movieDetails;
    
}

+ (NSMutableArray<Movie *> *)parseMovies:(NSDictionary *) moviesDic {
    
    NSArray *moviesResultArray = [moviesDic objectForKey: @"results"];
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *movie in moviesResultArray) {
        
        Movie *currentMovie = [[Movie alloc] init];
        
        currentMovie.movieID = [movie objectForKey: @"id"];
        currentMovie.title = [movie objectForKey: @"original_title"];
        currentMovie.overview = [movie objectForKey: @"overview"];
        currentMovie.vote_avegare = [movie objectForKey:@"vote_average"];
        
        // Image
        NSString *poster_path = [movie objectForKey: @"poster_path"];
        
        if (![poster_path isKindOfClass: NSNull.class]) {
            currentMovie.imageURL = [imageBaseURL stringByAppendingString: poster_path];
            
            [movies addObject:currentMovie];
            
            currentMovie = nil;
        }
    }
    
    return movies;
}

@end
