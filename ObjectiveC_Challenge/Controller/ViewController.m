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


@interface ViewController ()
 
@end

@implementation ViewController
BOOL isFiltred;


dispatch_group_t group;
- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltred = false;
    _myService = Service.new;
    self.searchBar.delegate = self;
    _movies_mainTableView.dataSource = self;
    _movies_mainTableView.delegate = self;
    
     group = dispatch_group_create();
    
    dispatch_group_enter(group);

    [_myService fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        
        // Sort by vote average
        self.popularMovies = [self sortMovieArrayByVoteAverage: movies];
        
        // Get just the first two popular movies
        self.filtedPopularArray = [self->_popularMovies subarrayWithRange: NSMakeRange (0, 2)];
        dispatch_group_leave(group);
    }];
    
     dispatch_group_enter(group);
    [_myService fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        
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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Movies";
}


// MARK: - Request Movies filtred when taped enter button
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   _filteredAllMovies = [[NSMutableArray alloc] init];
     __block NSArray<Movie *> *mov = [[NSArray alloc] init];
    _myService.strFindMe = searchBar.text;
     
     dispatch_group_enter(group);
    [_myService fetchMovies:RESULT_SEARCH completion:^(NSMutableArray * movies) {
           
        mov = movies;
       // mov = movies;
           dispatch_group_leave(group);
       }];
    // [self.movies_mainTableView reloadData];
     NSLog(@"%@", searchBar.text);
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     
    if (searchText.length == 0){
        isFiltred = NO;
        [self.movies_mainTableView reloadData];
    }else{
        isFiltred = true;
        _filteredAllMovies = [[NSMutableArray alloc] init];

        for (Movie *movie in _filtedPopularArray) {
            NSRange nameRange = [movie.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound){
                [_filteredAllMovies addObject:movie];
            }
            
        }
        
        for (Movie *movie in _filtedNowPlayingArray) {
            NSRange nameRange = [movie.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound){
                [_filteredAllMovies addObject:movie];
            }
            
        }
         [self.movies_mainTableView reloadData];
    }
    
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
    
    if(isFiltred){
        cell.movie = _filteredAllMovies[indexPath.row];
    }
    // Popular Section
    else if(indexPath.section == 0) {
         cell.movie = _filtedPopularArray[indexPath.row];
    }
    // Now Playing Section
     else if (indexPath.section == 1){
        cell.movie = _filtedNowPlayingArray[indexPath.row];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)sortMovieArrayByVoteAverage:(NSMutableArray<Movie *> *)movieArray {
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"vote_avegare" ascending:NO];
    
    NSArray *sortedArray = [movieArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltred) {
        return _filteredAllMovies.count;
    }else{
        if (section == 0) { return self.filtedPopularArray.count; }
           else { return self.filtedNowPlayingArray.count; }
    }
   
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
    if (isFiltred){
        return 1;
    }
    return 2;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *movieID = NSNumber.new;
    
    if (isFiltred) {
        movieID = _filteredAllMovies[indexPath.row].movieID;
    }else if (indexPath.section == 0) {
        movieID = _filtedPopularArray[indexPath.row].movieID;
    } else {
        movieID = _filtedNowPlayingArray[indexPath.row].movieID;
    }

    [self performSegueWithIdentifier:@"movieDetailSegue" sender: movieID];
}

@end
