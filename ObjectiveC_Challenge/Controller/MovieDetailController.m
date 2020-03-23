//
//  MovieDetailController.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 19/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "MovieDetailController.h"
#import "Service.h"
#import "Movie.h"

@interface MovieDetailController ()

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Service *myService = Service.new;
    
    [myService fetchMovieDetails:_movieID completion:^(Movie * movie) {
        self.movie = movie;
        
        dispatch_async(dispatch_get_main_queue(), ^{
             self.movieDetailImage.layer.cornerRadius = 10;
            self.movieDetailImage.image = self.movie.movieImage;
            self.movieTitleLabel.text = self.movie.title;
            self.movieGenreLabel.text = self.movie.genres;
            self.movieVoteAverageLabel.text = [NSString stringWithFormat:@"%.01f", self.movie.vote_avegare.doubleValue];
            self.movieOverviewTextView.text = self.movie.overview;
        });
    }];
      
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

@end
