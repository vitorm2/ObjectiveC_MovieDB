//
//  TableViewCell.m
//  ObjectiveC_Challenge
//
//  Created by Guilherme Rangel on 18/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setMovie:(Movie *)movie {

    self.movieTitle.text = movie.title;
    self.movieOverview.text = movie.overview;
    self.movieImage.layer.cornerRadius = 10;
    self.movieRate.text = [NSString stringWithFormat:@"%.01f", movie.vote_avegare.doubleValue];
    [self.movieImage loadImageWithStringURL: movie.imageURL];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
