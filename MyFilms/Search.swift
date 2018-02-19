//
//  Search.swift
//  MyFilms
//
//  Created by Sophie Traynor on 01/12/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import Foundation

class Search {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        /*guard !searchText.isEmpty else
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
         addMovieBtn.isEnabled = false*/
        
        currentMovies = movies.filter({ movie -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return movie.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return movie.rating == 1 }
                return movie.name.lowercased().contains(searchText.lowercased()) &&
                    movie.rating == 1
            case 2:
                if searchText.isEmpty { return movie.rating == 2 }
                return movie.name.lowercased().contains(searchText.lowercased()) &&
                    movie.rating == 2
            case 3:
                if searchText.isEmpty { return movie.rating == 3 }
                return movie.name.lowercased().contains(searchText.lowercased()) &&
                    movie.rating == 3
            case 4:
                if searchText.isEmpty { return movie.rating == 4 }
                return movie.name.lowercased().contains(searchText.lowercased()) &&
                    movie.rating == 4
            case 5:
                if searchText.isEmpty { return movie.rating == 5 }
                return movie.name.lowercased().contains(searchText.lowercased()) &&
                    movie.rating == 5
            default:
                return false
            }
        })
        table.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        switch selectedScope {
        case 0:
            currentMovies = movies
        case 1:
            currentMovies = movies.filter({ movie -> Bool in
                movie.rating == 1
            })
        case 2:
            currentMovies = movies.filter({ movie -> Bool in
                movie.rating == 2
            })
        case 3:
            currentMovies = movies.filter({ movie -> Bool in
                movie.rating == 3
            })
        case 4:
            currentMovies = movies.filter({ movie -> Bool in
                movie.rating == 4
            })
        case 5:
            currentMovies = movies.filter({ movie -> Bool in
                movie.rating == 5
            })
        default:
            break
        }
        table.reloadData()
    }
}
