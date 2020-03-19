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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Movie *myMovie =[[Movie alloc] init];
    _myService = [[Service alloc] init];
   
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    _popularMovies_tableView.dataSource = self;
    _popularMovies_tableView.delegate = self;
    
//    [myService fetchMovieDetails: 552 completion:^(Movie * movieDetails) {
//        NSLog(movieDetails.title);
//    }];
    
    [_myService fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
       
        self->_popularMovies = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_popularMovies_tableView reloadData];
        });
        
    }];
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
        
      if (indexPath.section == 0) {
        cell.movieTitle.text = _popularMovies[indexPath.row].title;
      } else {
          cell.movieTitle.text = @"VAMO MEU";
      }
        
        [_myService fetchImageData:_popularMovies[indexPath.row].imageURL completion:^(NSData * data){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.movieImage.image = [[UIImage alloc] initWithData:data];
                
            });
        }];
        
        return cell;
    
    
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
        return @"Now Playing Movies";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"movieDetailSegue" sender: _popularMovies[indexPath.row]];
//    NSLog(@"CELL: %d, SECTION: %d", indexPath.row, indexPath.section);
}


@end
