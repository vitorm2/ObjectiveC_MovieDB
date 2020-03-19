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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Movie *myMovie =[[Movie alloc] init];
    Service *myService = [[Service alloc] init];
   
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    _popularMovies_tableView.dataSource = self;
    _popularMovies_tableView.delegate = self;
    
//    [myService fetchMovieDetails: 552 completion:^(Movie * movieDetails) {
//        NSLog(movieDetails.title);
//    }];
    
    [myService fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
       
        self->_popularMovies = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_popularMovies_tableView reloadData];
        });
        
    }];
}





- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.movieTitle.text = _popularMovies[indexPath.row].title;
    cell.movieImage.image = [UIImage imageNamed:@"lion"];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _popularMovies.count;
}


@end
