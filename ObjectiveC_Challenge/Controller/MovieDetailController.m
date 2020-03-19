//
//  MovieDetailController.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 19/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "MovieDetailController.h"
#import "Movie.h"

@interface MovieDetailController ()

@end

@implementation MovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _movieDetailImage.layer.cornerRadius = 10;
    
    _movieDetailImage.image = _movie.movieImage;
    _movieTitleLabel.text = _movie.title;
    _movieGenreLabel.text = _movie.genres;
    _movieVoteAverageLabel.text = [_movie.vote_avegare stringValue];
    _movieOverviewTextView.text = _movie.overview;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

@end
