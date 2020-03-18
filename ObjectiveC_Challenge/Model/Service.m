//
//  Service.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 17/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Movie.h"
#import "NSArray+GenreCategory.h"

@implementation Service


//NSString *urlString = @"https://api.themoviedb.org/3/movie/552?api_key=79bb37b9869aa0ed97dc7a23c93d0829";

static NSString *const API_key = @"79bb37b9869aa0ed97dc7a23c93d0829";
static NSString *const imageBaseURL = @"https://image.tmdb.org/t/p/w500";

- (void) fetchMovieDetails:(int)movieId completion:(void (^)(Movie*))callback {

    NSString *movieDetails_GET_URL = @"https://api.themoviedb.org/3/movie/";
    
    NSString *urlString = [NSString stringWithFormat: @"%@%d?api_key=%@", movieDetails_GET_URL,  movieId, API_key];
    NSURL *url = [NSURL URLWithString: urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Request error: %@", error);
            return;
        }
        
        NSError *err;
        
        NSDictionary *movieJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (error) {
            NSLog(@"JSON Serialization Error: %@", error);
            return;
        }
        
        @try {
            
            Movie *movieDetails = [[Movie alloc] init];
            
            movieDetails.title = [movieJSON objectForKey: @"original_title"];
            movieDetails.overview = [movieJSON objectForKey: @"overview"];
            movieDetails.vote_avegare = [movieJSON objectForKey:@"vote_average"];
            
            // Image
            NSString *poster_path = [movieJSON objectForKey: @"poster_path"];
            movieDetails.imageURL = [imageBaseURL stringByAppendingString: poster_path];
            
            // Genres
            NSArray *genresObjectArray = [movieJSON objectForKey: @"genres"];
            movieDetails.genres = [genresObjectArray getGenreFullString];
            
            
            callback(movieDetails);
        }
        
        @catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
    
}

@end

//        - API fetch string result
//        NSString *myString = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
