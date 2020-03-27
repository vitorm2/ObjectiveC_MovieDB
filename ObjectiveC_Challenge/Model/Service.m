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

@implementation Service


//NSString *urlString = @"https://api.themoviedb.org/3/movie/552?api_key=79bb37b9869aa0ed97dc7a23c93d0829";

static NSString *const API_key = @"79bb37b9869aa0ed97dc7a23c93d0829";
static NSString *const imageBaseURL = @"https://image.tmdb.org/t/p/w500";
static NSString *const urlBase = @"https://api.themoviedb.org/3/movie/";
NSURL *url;
NSString *strFormated;

- (void) fetchMovieDetails:(NSNumber* )movieId completion:(void (^)(Movie*))callback {
    
    
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
            
            Movie *movieDetails = [[Movie alloc] init];
            
            movieDetails.title = [movieJSON objectForKey: @"original_title"];
            movieDetails.overview = [movieJSON objectForKey: @"overview"];
            movieDetails.vote_avegare = [movieJSON objectForKey:@"vote_average"];
            
            // Image
            NSString *poster_path = [movieJSON objectForKey: @"poster_path"];
            movieDetails.imageURL = [imageBaseURL stringByAppendingString: poster_path];
            
            // Genres
            NSArray *genresObjectArray = [movieJSON objectForKey: @"genres"];
            movieDetails.genres = [genresObjectArray getStringWithCommas: @"name"];
            
            callback(movieDetails);
        }
        
        @catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
    
}

- (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback {
    
    NSString *movies_GET_URL = [NSString alloc];
    
    if (moviesCategory == POPULAR) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/popular";
    } else if (moviesCategory == NOW_PLAYING) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/now_playing";
    }else if (moviesCategory == RESULT_SEARCH) {
        
        NSString *urlSearch = @"https://api.themoviedb.org/3/search/movie?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US&query=";

       strFormated = [NSString stringWithFormat: @"%@%@", urlSearch, _strFindMe];

       
        
    }
    if (moviesCategory == RESULT_SEARCH){
        url = [NSURL URLWithString: strFormated];
    }else {
        NSString *urlString = [NSString stringWithFormat: @"%@?api_key=%@", movies_GET_URL, API_key];
        url = [NSURL URLWithString: urlString];
    }
    
    
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
            
            // JSON Dictionary object array
            NSArray *moviesResultArray = [moviesJSON objectForKey: @"results"];
            
            // Movie object array
            NSMutableArray *movies = [[NSMutableArray alloc] init];
            if (moviesCategory == RESULT_SEARCH){
                 
               }else {
                   for (NSDictionary *movie in moviesResultArray) {
                                  
                                  Movie *currentMovie = [[Movie alloc] init];
                                  
                                  currentMovie.movieID = [movie objectForKey: @"id"];
                                  currentMovie.title = [movie objectForKey: @"original_title"];
                                  currentMovie.overview = [movie objectForKey: @"overview"];
                                  currentMovie.vote_avegare = [movie objectForKey:@"vote_average"];
                                  
                                  // Image
                                  NSString *poster_path = [movie objectForKey: @"poster_path"];
                                  currentMovie.imageURL = [imageBaseURL stringByAppendingString: poster_path];
                                  
                                  [movies addObject:currentMovie];
                                  
                                  currentMovie = nil;
                              }
               }
           
            NSLog(@"%lu", (unsigned long)movies.count);
            callback(movies);
            
        }
        
        @catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
}

- (void)downloadImages:(NSArray<Movie *> *)movies completion:(void (^)(NSMutableDictionary<NSString *,UIImage *> *))callback {
    
    NSMutableDictionary<NSString *,UIImage *> *myDic = [[NSMutableDictionary<NSString *,UIImage *> alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    
    
    for (Movie *movie in movies) {
        dispatch_group_enter(group);
        
        [self fetchImageData: movie.imageURL completion:^(UIImage * image, NSString * imgURL) {
            
            [myDic  setObject:image forKey:imgURL];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        callback(myDic);
    });
}


- (void)fetchImageData:(NSString*) imageURL completion:(void (^)(UIImage *, NSString *))callback {
    
    NSURL *imgURL = [NSURL URLWithString: imageURL];
    
    [[NSURLSession.sharedSession dataTaskWithURL:(imgURL) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *returnImage = [[UIImage alloc] initWithData:data];
            
            callback(returnImage, imageURL);
        }else{
            NSLog(@"IMAGE FETCH ERROR: %@",error);
        }
    }] resume] ;
    
}


@end
