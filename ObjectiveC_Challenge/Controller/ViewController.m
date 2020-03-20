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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myService = Service.new;
    
    _popularMovies_tableView.dataSource = self;
    _popularMovies_tableView.delegate = self;
    
    [_myService fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        
        self->_popularMovies = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_popularMovies_tableView reloadData];
        });
        
    }];
    
    [_myService fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        
        self->_nowPlayingMovies = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_popularMovies_tableView reloadData];
        });
        
    }];
    
    
    
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





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movie *)sender {
    
    if ([[segue identifier] isEqualToString:@"movieDetailSegue"]) {
        MovieDetailController *vc = [segue destinationViewController];
        vc.movie = sender;
        
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    
    // Popular Section
    if (indexPath.section == 0) {
        
        cell.movieTitle.text = _popularMovies[indexPath.row].title;
        cell.movieOverview.text = _popularMovies[indexPath.row].overview;
        cell.movieImage.layer.cornerRadius = 10;
        NSString *rateStr = [_popularMovies[indexPath.row].vote_avegare stringValue];
        cell.movieRate.text = rateStr;
        
        if (_popularMovies[indexPath.row].movieImage == nil) {
            
            [self fetchImage:_popularMovies[indexPath.row].imageURL completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_popularMovies[indexPath.row].movieImage = image;
                });
            }];
        } else { cell.movieImage.image = _popularMovies[indexPath.row].movieImage; }
        
        
        
        
    // Now Playing Section
    } else if (indexPath.section == 1){
   
        
    NSMutableArray * nowPlayingMoviesOrdened = [[NSMutableArray alloc]initWithObjects:_nowPlayingMovies,nil];
    [self bubbleSort: nowPlayingMoviesOrdened];

    
        cell.movieTitle.text = _nowPlayingMovies[indexPath.row].title;
        cell.movieOverview.text = _nowPlayingMovies[indexPath.row].overview;
        cell.movieImage.layer.cornerRadius = 10;
        NSString *rateStr = [_nowPlayingMovies[indexPath.row].vote_avegare stringValue];
        cell.movieRate.text = rateStr;
        
        
        if (_nowPlayingMovies[indexPath.row].movieImage == nil) {
            [self fetchImage:_nowPlayingMovies[indexPath.row].imageURL completion:^(UIImage * image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_nowPlayingMovies[indexPath.row].movieImage = image;
                });
            }];
        } else { cell.movieImage.image = _nowPlayingMovies[indexPath.row].movieImage; }
    }
    
    return cell;
    
    
}

- (void)fetchImage:(NSString *)imageURL completion:(void (^)(UIImage *))callback {
    [_myService fetchImageData:imageURL completion:^(NSData * data){
        UIImage *myImage = [[UIImage alloc] initWithData:data];
        callback(myImage);
    }];
}

- (NSArray *)bubbleSort:(NSMutableArray *)sortedArray
{
   long count = sortedArray.count;
   bool swapped = YES;
   while (swapped)
   {
   swapped = NO;

      for (int i = 1; i < count; i++)
      {
          int x = [sortedArray[i-1] intValue];
          int y = [sortedArray[i] intValue];

          if (x > y)
          {
               [sortedArray exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
               swapped = YES;
          }
      }
   }
   return sortedArray;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return _popularMovies.count;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Popular Movies";
    } else {
        return @"Now Playing";
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
    
    if (indexPath.section == 0) {
        NSNumber *movieID = _popularMovies[indexPath.row].movieID;
        [_myService fetchMovieDetails:movieID completion:^(Movie * movie) {
            dispatch_async(dispatch_get_main_queue(), ^{
                movie.movieImage = self->_popularMovies[indexPath.row].movieImage;
                [self performSegueWithIdentifier:@"movieDetailSegue" sender: movie];
            });
        }];
    } else {
        NSNumber *movieID = _nowPlayingMovies[indexPath.row].movieID;
        [_myService fetchMovieDetails:movieID completion:^(Movie * movie) {
            dispatch_async(dispatch_get_main_queue(), ^{
                movie.movieImage = self->_nowPlayingMovies[indexPath.row].movieImage;
                [self performSegueWithIdentifier:@"movieDetailSegue" sender: movie];
            });
        }];
    }
}



@end
