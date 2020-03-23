//
//  ViewController.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 16/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Service.h"
#import "TableViewCell.h"
#import "MovieDetailController.h"
//#import "NSArray+RemoveEquals.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myService = Service.new;
    
    _movies_mainTableView.dataSource = self;
    _movies_mainTableView.delegate = self;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [_myService fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        
        // Sort by vote average
        self.popularMovies = [self sortMovieArrayByVoteAverage: movies];
        
        // Get just the first two popular movies
        self.filtedPopularArray = [self->_popularMovies subarrayWithRange: NSMakeRange (0, 2)];
        
        // Download all Popular movies images
        [self.myService downloadImages:self.filtedPopularArray completion:^(NSDictionary<NSString *,UIImage *> *resultDictionary) {
            self.popularMoviesImages = resultDictionary;
            dispatch_group_leave(group);
        }];
    }];
    
     dispatch_group_enter(group);
    [_myService fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        
        // Sort by vote average
        self.nowPlayingMovies = [self sortMovieArrayByVoteAverage: movies];
        
        // Download all nowPlaying movies images
        [self.myService downloadImages:self.nowPlayingMovies completion:^(NSDictionary<NSString *,UIImage *> *resultDictionary) {
            self.nowPlayingMoviesImages = resultDictionary;
            dispatch_group_leave(group);
        }];
    }];
    
    
    
    // When the two requisitions are been complete, enter here
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // Remove nowPlaying movies that contain in popular collection
        self.filtedNowPlayingArray = [self.nowPlayingMovies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT movieID IN %@", [self.filtedPopularArray valueForKey:@"movieID"]]];
        
        [self.movies_mainTableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"Movies";
    UISearchController *searchController =   UISearchController.new;
//    searchController.searchResultsUpdater = resultsViewController
    searchController.obscuresBackgroundDuringPresentation = true;
//    searchController.delegate = resultsViewController
//    searchController.searchBar.delegate = resultsViewController
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = false;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *)sender {
    
    if ([[segue identifier] isEqualToString:@"movieDetailSegue"]) {
        MovieDetailController *movieDetailsViewController = [segue destinationViewController];
        movieDetailsViewController.movieID = sender;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    // Popular Section
    if (indexPath.section == 0) {
        
        cell.movieTitle.text = _filtedPopularArray[indexPath.row].title;
        cell.movieOverview.text = _filtedPopularArray[indexPath.row].overview;
        cell.movieImage.layer.cornerRadius = 10;
        cell.movieRate.text = [NSString stringWithFormat:@"%.01f", _filtedPopularArray[indexPath.row].vote_avegare.doubleValue];
        cell.movieImage.image = _popularMoviesImages[_filtedPopularArray[indexPath.row].imageURL];
        
    // Now Playing Section
    } else if (indexPath.section == 1){

        cell.movieTitle.text = _filtedNowPlayingArray[indexPath.row].title;
        cell.movieOverview.text = _filtedNowPlayingArray[indexPath.row].overview;
        cell.movieImage.layer.cornerRadius = 10;
        cell.movieRate.text = [NSString stringWithFormat:@"%.01f", _filtedNowPlayingArray[indexPath.row].vote_avegare.doubleValue];
        cell.movieImage.image = _nowPlayingMoviesImages[_filtedNowPlayingArray[indexPath.row].imageURL];
    }
    
    return cell;
}


- (NSArray *)sortMovieArrayByVoteAverage:(NSMutableArray<Movie *> *)movieArray {
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_avegare" ascending:NO];
    NSArray *sortedArray = [movieArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) { return self.filtedPopularArray.count; }
    else { return self.filtedNowPlayingArray.count; }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    if(_filtedPopularArray.count != 0 && _filtedNowPlayingArray != 0) {
        if (section == 0) { return @"Popular Movies"; }
        else { return @"Now Playing"; }
    } else {
        return @"";
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *movieID = NSNumber.new;
    
    if (indexPath.section == 0) {
        movieID = _filtedPopularArray[indexPath.row].movieID;
    } else {
        movieID = _filtedNowPlayingArray[indexPath.row].movieID;
    }

    [self performSegueWithIdentifier:@"movieDetailSegue" sender: movieID];
}

@end
