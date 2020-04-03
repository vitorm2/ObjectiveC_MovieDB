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
#import <QuartzCore/QuartzCore.h>
#import "CustomImageView.h"
#import "ImageCache.h"
#import "SearchViewController.h"

@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];

    _movies_mainTableView.dataSource = self;
    _movies_mainTableView.delegate = self;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);

    [Service fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        
        // Sort by vote average
        self.popularMovies = [self sortMovieArrayByVoteAverage: movies];
        
        // Get just the first two popular movies
        self.filtedPopularArray = [self->_popularMovies subarrayWithRange: NSMakeRange (0, 2)];
        dispatch_group_leave(group);
    }];
    
     dispatch_group_enter(group);
    [Service fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        
        // Sort by vote average
        self.nowPlayingMovies = [self sortMovieArrayByVoteAverage: movies];
        dispatch_group_leave(group);
    }];
    
    
    
    // When the two requisitions are been complete, enter here
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // Remove nowPlaying movies that contain in popular collection
        self.filtedNowPlayingArray = [self.nowPlayingMovies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT movieID IN %@", [self.filtedPopularArray valueForKey:@"movieID"]]];
        
        [self.movies_mainTableView reloadData];
    });
}


- (void)setupNavigationBar {
    
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = true;
    
    
    // Initialize search view controller
    UINavigationController* searchNavigation =[self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigation"];

    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController: searchNavigation];
    
    SearchViewController *searchViewController = searchNavigation.topViewController;
    
    searchController.searchResultsUpdater = searchViewController;
    searchController.searchBar.delegate = searchViewController;
    
    
    searchController.obscuresBackgroundDuringPresentation = true;
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = false;
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
    if(indexPath.section == 0) {
         cell.movie = _filtedPopularArray[indexPath.row];
    }
    
    // Now Playing Section
     else if (indexPath.section == 1){
        cell.movie = _filtedNowPlayingArray[indexPath.row];
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
