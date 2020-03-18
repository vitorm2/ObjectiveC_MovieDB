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

@implementation Service

- (void) getMovieDetail:(NSString *)movieId {
    
    NSString *urlString = @"https://api.themoviedb.org/3/movie/552?api_key=79bb37b9869aa0ed97dc7a23c93d0829";
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w500";

    NSURL *url = [NSURL URLWithString: urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
//        - API fetch string result
//        NSString *myString = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        NSDictionary *movieJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (error) {
            NSLog(@"ERRO PARSE JSON");
            return;
        }
        
        Movie *movieDetails = [[Movie alloc] init];
        
        movieDetails.title = [movieJSON objectForKey: @"original_title"];
        movieDetails.overview = [movieJSON objectForKey: @"overview"];
        movieDetails.vote_avegare = [movieJSON objectForKey:@"vote_average"];
        
        
        // Image
        NSString *poster_path = [movieJSON objectForKey: @"poster_path"];
        movieDetails.imageURL = [baseUrl stringByAppendingString: poster_path];
        
        // Genre string constructor -----------------------------------
        NSArray *genresObjectArray = [movieJSON objectForKey: @"genres"];
        
        NSString *genreString = NSString.new;
        NSString *symbol = NSString.new;
        
        for (NSDictionary *genreObject in genresObjectArray) {
            NSString *genre = [genreObject objectForKey: @"name"];
            
            
            if (genreObject != genresObjectArray.lastObject) {
                symbol = @", ";
            } else {
                symbol = @".";
            }
            
            genre = [genre stringByAppendingString: symbol];
            genreString = [genreString stringByAppendingString: genre];
        }
        
        movieDetails.genres = genreString;
        
        //--------------------------------------------
        
        NSLog(@"Title: %@", movieDetails.title);
        NSLog(@"Vote average: %@", movieDetails.vote_avegare);
        NSLog(@"Genres: %@", movieDetails.genres);
        NSLog(@"ImageURL: %@", movieDetails.imageURL);
        NSLog(@"Overview: %@", movieDetails.overview);
        
    }] resume];
    
    
}

@end

