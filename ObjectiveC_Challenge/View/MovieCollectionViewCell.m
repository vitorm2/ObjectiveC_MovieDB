//
//  MovieCollectionViewCell.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@implementation MovieCollectionViewCell


- (void)setMovie:(Movie *)movie {
    
    self.movieTitle.text = movie.title;
    self.movieImage.layer.cornerRadius = 10;
    self.movieVoteAverage.text = [NSString stringWithFormat:@"%.01f", movie.vote_avegare.doubleValue];
    [self.movieImage loadImageWithStringURL: movie.imageURL];
    
}

@end
