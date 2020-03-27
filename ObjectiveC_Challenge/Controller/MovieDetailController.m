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
        
            self.movieTitleLabel.text = self.movie.title;
            self.movieGenreLabel.text = self.movie.genres;
            
            self.voteAverageImage.hidden = false;
            self.movieVoteAverageLabel.hidden = false;
            self.overviewLabel.hidden = false;
            
            self.movieVoteAverageLabel.text = [NSString stringWithFormat:@"%.01f", self.movie.vote_avegare.doubleValue];
            self.movieOverviewTextView.text = self.movie.overview;
            
            [self.movieDetailImage loadImageWithStringURL: self.movie.imageURL];
            self.movieDetailImage.layer.cornerRadius = 10;
        });
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

@end
