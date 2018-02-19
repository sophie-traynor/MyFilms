//
//  MovieTableViewController.swift
//  MyFilms
//
//  Created by Sophie Traynor on 02/11/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import UIKit
import os.log

class MovieTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    @IBOutlet var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addMovieBtn: UIBarButtonItem!
    
    var movies = [Movie]()
    var currentMovies = [Movie]() //updateTable

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem

        //load saved movies or sample data if no saved movies
        if let savedMovies = loadMovies() {
            movies += savedMovies
        }
        else {
            //Load the sample data.
            loadSampleMovies()
        }
        currentMovies = movies
        
        setUpSearchBar()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem
            .done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated: false)
        searchBar.inputAccessoryView = toolbar
        
    }

    //MARK: done button
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Search
    
    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "Search for Movie"
        self.tableView.contentOffset = CGPoint(x:0.0, y:100.0);
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else
        {
            currentMovies = movies
            table.reloadData()
            addMovieBtn.isEnabled = true
            return
            
        }
        currentMovies = movies.filter({ (movie) -> Bool in
            movie.name.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
        addMovieBtn.isEnabled = false
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
        if !(searchBar.text?.isEmpty)!
        {
            switch selectedScope {
            case 0:
                let temp = currentMovies
                currentMovies = temp
            case 1:
                currentMovies = currentMovies.sorted(by: { $0.rating < $1.rating })
            case 2:
                currentMovies = currentMovies.sorted(by: { $0.rating > $1.rating })
            default:
                break
            }
        }
        else
        {
            switch selectedScope {
            case 0:
                currentMovies = movies
            case 1:
                currentMovies = movies.sorted(by: { $0.rating < $1.rating })
            case 2:
                currentMovies = movies.sorted(by: { $0.rating > $1.rating })
            default:
                break
            }
        }
        
     table.reloadData()
     }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MovieTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MovieTableViewCell.")
        }
        
        //Fetches the appropriate movie for the data source layout.
        let movie = currentMovies[indexPath.row]

        cell.movieNameLabel.text = movie.name
        cell.photoImageView.image = movie.photo
        cell.ratingControl.rating = movie.rating

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if !(searchBar.text?.isEmpty)! {
                
                for(index, value) in movies.enumerated()
                {
                    if value.name == currentMovies[indexPath.row].name
                    {
                        currentMovies.remove(at: indexPath.row)
                        movies.remove(at: index)
                    }
                }
                
            }
            else {
                // Delete the row from the data source
                currentMovies.remove(at: indexPath.row)
                movies.remove(at: indexPath.row)
            }
            
            saveMovies()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new movie", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let movieDetailViewController = segue.destination as? MovieViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMovieCell = sender as? MovieTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            
            let selectedMovie = currentMovies[indexPath.row]
            movieDetailViewController.movie = selectedMovie
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    //MARK: Actions
    
    @IBAction func unwindToMovieList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MovieViewController, let movie = sourceViewController.movie {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                if !(searchBar.text?.isEmpty)! {
                    
                    for(index, value) in movies.enumerated()
                    {
                        if value.name == currentMovies[selectedIndexPath.row].name
                        {
                            //Update existing movie in both arrays
                            movies[index] = movie
                            currentMovies[selectedIndexPath.row] = movie
                        }
                    }
                }
                else {
                    currentMovies[selectedIndexPath.row] = movie
                }
                table.reloadData()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                //currentMovies = movies
                movies = currentMovies

            }
            else{
                //Add a new movie
                let newIndexPath = IndexPath(row: movies.count, section: 0)
                currentMovies.append(movie)
                movies = currentMovies
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            saveMovies()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleMovies(){
        
        let photo1 = UIImage(named: "movie1")
        let photo2 = UIImage(named: "movie2")
        let photo3 = UIImage(named: "movie3")
        
        guard let movie1 = Movie(name: "Avengers", photo: photo1, rating: 5, year: "2000", genre: "Action", age: 3, review: "") else {
            fatalError("Unable to instantiate movie1")
        }
        
        guard let movie2 = Movie(name: "Guardians of the Galaxy", photo: photo2, rating: 5, year: "2001", genre: "Fantasy", age: 2, review: "") else {
            fatalError("Unable to instantiate movie2")
        }
        
        guard let movie3 = Movie(name: "Spiderman", photo: photo3, rating: 3, year: "2002", genre: "Adventure", age: 1, review: "") else {
            fatalError("Unable to instantiate movie2")
        }
        
        movies += [movie1, movie2, movie3]
    }
    
    private func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Movie.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Movies successfully saved", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save movies", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMovies() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
    }
    
}

