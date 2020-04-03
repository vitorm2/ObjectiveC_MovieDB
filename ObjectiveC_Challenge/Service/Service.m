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
#import <UIKit/UIKit.h>
#import "Parse.h"


@implementation Service


//NSString *urlString = @"https://api.themoviedb.org/3/movie/552?api_key=79bb37b9869aa0ed97dc7a23c93d0829";

static NSString *const API_key = @"79bb37b9869aa0ed97dc7a23c93d0829";
static NSString *const urlBase = @"https://api.themoviedb.org/3/movie/";

+ (void) fetchMovieDetails:(NSNumber* )movieId completion:(void (^)(Movie*))callback {
    
    
    NSString *urlString = [NSString stringWithFormat: @"%@%@?api_key=%@", urlBase,  movieId, API_key];
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
            Movie *resultMovie = [Parse parseMovie: movieJSON];
            callback(resultMovie);
            
        }@catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
    
}


+ (void)searchMovies:(NSString *)searchString completion:(void (^)(NSMutableArray *))callback {
    
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/search/movie?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US&query=%@", searchString];
    NSURL *url = [NSURL URLWithString: urlString];
    
      [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          if (error) {
              NSLog(@"Request error: %@", error);
              return;
          }
          
          NSError *err;
          NSDictionary *moviesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
          
          if (error) {
              NSLog(@"JSON Serialization Error: %@", error);
              return;
          }
          
          @try {
              NSMutableArray<Movie *> *movies = [Parse parseMovies:moviesJSON];
              callback(movies);
            
          }
          @catch ( NSException *e ) {
              NSLog(@"JSON Parse error: %@", e);
              return;
          }
          
          
     }] resume];
    
    
}

+ (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback {
    
    NSString *movies_GET_URL = [NSString alloc];
    
    if (moviesCategory == POPULAR) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/popular";
    } else if (moviesCategory == NOW_PLAYING) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/now_playing";
    }
    
    NSString *urlString = [NSString stringWithFormat: @"%@?api_key=%@", movies_GET_URL, API_key];
    NSURL *url = [NSURL URLWithString: urlString];
    
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Request error: %@", error);
            return;
        }
        
        NSError *err;
        NSDictionary *moviesJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (error) {
            NSLog(@"JSON Serialization Error: %@", error);
            return;
        }
        
        @try {
            NSMutableArray<Movie *> *movies = [Parse parseMovies:moviesJSON];
            callback(movies);
        }
        
        @catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
}

+ (void)fetchImageData:(NSString*) imageURL completion:(void (^)(UIImage *))callback {
    
    NSURL *imgURL = [NSURL URLWithString: imageURL];
    
    [[NSURLSession.sharedSession dataTaskWithURL:(imgURL) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *returnImage = [[UIImage alloc] initWithData:data];
            
            callback(returnImage);
        }else{
            NSLog(@"IMAGE FETCH ERROR: %@",error);
        }
    }] resume] ;
    
}


@end
