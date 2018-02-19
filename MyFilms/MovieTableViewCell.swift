//
//  MovieTableViewCell.swift
//  MyFilms
//
//  Created by Sophie Traynor on 02/11/2017.
//  Copyright © 2017 Sophie Traynor. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
