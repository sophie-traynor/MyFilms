//
//  Movie.swift
//  MyFilms
//
//  Created by Sophie Traynor on 02/11/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import UIKit
import os.log

class Movie: NSObject, NSCoding {
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var year: String
    var genre: String
    var age: Int
    var review: String?

    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let year = "year"
        static let genre = "genre"
        static let age = "age"
        static let review = "review"

    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, year: String, genre: String, age: Int, review: String?) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        guard !year.isEmpty else {
            return nil
        }
        
        guard !genre.isEmpty else {
            return nil
        }
        
        // The age rating must be between 0 and 5 inclusively
        guard (age >= 0) && (age <= 5) else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }

        //Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.year = year
        self.genre = genre
        self.age = age
        self.review = review

    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(genre, forKey: PropertyKey.genre)
        aCoder.encode(age, forKey: PropertyKey.age)
        aCoder.encode(review, forKey: PropertyKey.review)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //The name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey:PropertyKey.name) as? String else{
            
            os_log("Unable to decode the name for a Movie object", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let year = aDecoder.decodeObject(forKey: PropertyKey.year) as? String else{
            os_log("Unable to decode the year for a Movie object", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let genre = aDecoder.decodeObject(forKey: PropertyKey.genre) as? String else{
            os_log("Unable to decode the genre for a Movie object", log: OSLog.default, type: .debug)
            return nil
        }
        
        //Because photo is an optional property for Movie, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let review = aDecoder.decodeObject(forKey: PropertyKey.review) as? String
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let age = aDecoder.decodeInteger(forKey: PropertyKey.age)
        
        //Must call designated initializer
        self.init(name: name, photo: photo, rating: rating, year: year, genre: genre, age: age, review: review)
    }
}
