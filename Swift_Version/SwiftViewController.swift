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
        
        main_tableView.dataSource = self
        
        
        Service.fetchMovies(POPULAR) { (movies) in
            guard let movies = movies else { return }
            self.popularMoviesArray = movies as! [Movie]
            
            DispatchQueue.main.async {
                self.main_tableView.reloadData()
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
        cell.movie = popularMoviesArray[indexPath.row]
        
        return cell
    }
    
    
}
