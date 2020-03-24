//
//  SwiftViewController.swift
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 24/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {

    @IBOutlet weak var main_tableView: UITableView!
    
    
    var popularMoviesArray: [Movie] = []
    var popularMoviesImages: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myService = Service()
        
        main_tableView.dataSource = self
        
        
        myService.fetchMovies(POPULAR) { (movies) in
            guard let movies = movies else { return }
            self.popularMoviesArray = movies as! [Movie]
            
            myService.downloadImages(self.popularMoviesArray) { (returnDicWithAllImages) in
                guard let returnDicWithAllImages = returnDicWithAllImages else { return }
                self.popularMoviesImages = returnDicWithAllImages
                
                DispatchQueue.main.async {
                    self.main_tableView.reloadData()
                }
            }
        }
        
        
    }

}

extension SwiftViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableItem") as! TableViewCell
        
        cell.movieTitle?.text = popularMoviesArray[indexPath.row].title
        cell.movieOverview?.text = popularMoviesArray[indexPath.row].overview
        cell.movieRate?.text = (popularMoviesArray[indexPath.row].vote_avegare).stringValue
        
        let movieURL = popularMoviesArray[indexPath.row].imageURL!
        cell.movieImage?.image = (popularMoviesImages[movieURL] as? UIImage) ?? UIImage()
        
        return cell
    }
    
    
}
