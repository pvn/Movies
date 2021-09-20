//
//  MovieTableViewCell.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//

import UIKit

class MovieListCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var buttonBook: UIButton!
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(movie: MovieItemView, searchHighlightText: String) {
        self.posterImageView.image = UIImage(data: movie.posterImageData ?? Data())
        self.labelMovieTitle.setHighlighted(movie.movieTitle, with: searchHighlightText)
        self.labelReleaseDate.text = movie.movieReleaseDate.toString()
        
        self.posterImageView.setUrl(movie.posterURL!, placeHolderImgName: "Sony-Logo")
        self.posterImageView.layer.cornerRadius = 25;
        self.posterImageView.layer.masksToBounds = true;
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
    }
    
    @IBAction func book(sender: UIButton) {
        
    }

}
