//
//  SearchViewController.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "SearchViewController.h"
#import "MovieCollectionViewCell.h"
#import "Service.h"
#import "MovieDetailController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _main_collectionView.delegate = self;
    _main_collectionView.dataSource = self;
    
//    self.navigationController.navigationBar.hidden = true;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
    [Service searchMovies:searchBar.text completion:^(NSMutableArray * movies) {
    
        self.searchResultMovies = movies;
        
        dispatch_async_and_wait(dispatch_get_main_queue(), ^{
            [self.main_collectionView reloadData];
        });
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchResultMovies = NSArray.new;
    
    [self.main_collectionView reloadData];
    
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _searchResultMovies.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleCollectionIdentifier = @"searchMovieCell";
       
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: simpleCollectionIdentifier forIndexPath: indexPath];
    
    cell.movie = _searchResultMovies[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"searchSegueIdentifier" sender: _searchResultMovies[indexPath.row].movieID];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *) sender {
    
    if ([[segue identifier] isEqualToString:@"searchSegueIdentifier"]) {
         MovieDetailController *movieDetailsViewController = [segue destinationViewController];
         movieDetailsViewController.movieID = sender;
     }
}





@end
