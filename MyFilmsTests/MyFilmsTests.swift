//
//  MyFilmsTests.swift
//  MyFilmsTests
//
//  Created by Sophie Traynor on 02/11/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import XCTest
@testable import MyFilms

class MyFilmsTests: XCTestCase {
    
    
    //MARK: Movie class tests
    
    //Confirm that the Movie initializer returns a Movie object when passed valid parameters.
    func testMovieInitializationSucceeds() {

        //Zero rating
        let zeroRatingMovie = Movie.init(name: "Zero", photo: nil, rating: 0, year: "2000", genre: "Action", age: 3, review: "test ")
        XCTAssertNotNil(zeroRatingMovie)

        //Highest positive rating
        let positiveRatingMovie = Movie.init(name: "Positive", photo: nil, rating: 5, year: "2000", genre: "Action", age: 3, review: "test ")
        XCTAssertNotNil(positiveRatingMovie)
        
        //lowest age rating
        let zeroAgeRatingMovie = Movie.init(name: "ZeroAge", photo: nil, rating: 5, year: "2000", genre: "Action", age: 0, review: "test ")
        XCTAssertNotNil(zeroAgeRatingMovie)
        
        //highest age rating
        let positiveAgeRatingMovie = Movie.init(name: "PositiveAge", photo: nil, rating: 5, year: "2000", genre: "Action", age: 5, review: "test ")
        XCTAssertNotNil(positiveAgeRatingMovie)
    }

    // Confirm that the Movie initialier returns nil when passed a negative rating or an empty name.
    func testMovieInitializationFails() {
        
        // Empty String
        let emptyStringMovie = Movie.init(name: "", photo: nil, rating: 0, year: "2000", genre: "Action", age: 3, review: "test ")
        XCTAssertNil(emptyStringMovie)
        
        // Empty year
        let emptyYearMovie = Movie.init(name: "emptyYear", photo: nil, rating: 0, year: "", genre: "Action", age: 3, review: "test ")
        XCTAssertNil(emptyYearMovie)
        
        // Empty genre
        let emptyGenreMovie = Movie.init(name: "emptyGenre", photo: nil, rating: 0, year: "2000", genre: "", age: 3, review: "test ")
        XCTAssertNil(emptyGenreMovie)
        
        // Negative rating
        let negativeRatingMovie = Movie.init(name: "Negative", photo: nil, rating: -1, year: "2000", genre: "Action", age: 3, review: "test ")
        XCTAssertNil(negativeRatingMovie)

        // Rating exceeds maximum
        let largeRatingMovie = Movie.init(name: "Large", photo: nil, rating: 6, year: "2000", genre: "Action", age: 3, review: "test ")
        XCTAssertNil(largeRatingMovie)
        
    }
}

