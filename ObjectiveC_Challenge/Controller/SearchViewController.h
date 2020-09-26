//
//  SearchViewController.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Service.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *main_collectionView;

@property NSArray<Movie *> *searchResultMovies;

@end

NS_ASSUME_NONNULL_END
