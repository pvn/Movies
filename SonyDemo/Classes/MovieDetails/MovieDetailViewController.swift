//
//  MovieDetailViewController.swift
//  SonyDemo
//
//  Created by Praveen Kumar on 19/09/21.
//  Copyright © 2021 Praveen Kumar. All rights reserved.

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var moviePosterView: UIImageView!
    
    var movie: MovieItemView? {
      didSet {
        configureView()
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
      if let movie = movie,
        let detailDescriptionLabel = labelMovieTitle,
        let moviePosterView = moviePosterView {
        detailDescriptionLabel.text = movie.movieTitle
        moviePosterView.setUrl(movie.posterURL!, placeHolderImgName: "Sony-Logo")
      }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
