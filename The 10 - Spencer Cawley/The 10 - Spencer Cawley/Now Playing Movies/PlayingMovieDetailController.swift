//
//  MovieDetailViewController.swift
//  The 10 - Spencer Cawley
//
//  Created by Spencer Cawley on 2/13/19.
//  Copyright © 2019 Spencer Cawley. All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailController: UIViewController {
    
    // Properties
    var movie: Movie?
    var movieController = MovieController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // IBOutlets
    @IBOutlet weak var playingMovieDetailImage: UIImageView!
    @IBOutlet weak var playingMovieDetailRating: UILabel!
    @IBOutlet weak var outOf10: UILabel!
    
    @IBOutlet weak var playingMovieDetailOverview: UILabel!
    @IBOutlet weak var playingMovieID: UILabel!
    @IBOutlet weak var playTrailerButton: UIButton!
    @IBOutlet weak var ticketButton: UIButton!
    
    var hideTicketButton: Bool?
    
    // Button to show Trailer on YouTube
    @IBAction func playTrailerButton(_ sender: UIButton) {
        guard let movie = movie else { return }
        let movieID = String(movie.id)
        TrailerController.fetchVideo(for: movieID) { (key) in
            if let key = key {
                DispatchQueue.main.async {
                         self.playMovie(with: key)
                }
            }
        }
    }
    
    // Button to show Fandango website
    @IBAction func getTicketsButton(_ sender: UIButton) {
        guard let movie = movie else { return }
        let title = movie.title
        let movieTitle = title.replacingOccurrences(of: " ", with: "%20")
        showSafariVC(url: "https://www.fandango.com/search/?q=\(movieTitle)")
    }
    
    func updateViews() {
        guard let movie = movie else { return }
        navigationItem.title = movie.title
        playingMovieDetailRating.text = "\(movie.voteAverage)"
        playingMovieDetailOverview.text = movie.overview
        playingMovieID.text = "\(movie.id)"
        playingMovieID.isHidden = true
        
        if playingMovieDetailRating.text == "\(0.0)" {
            playingMovieDetailRating.text = "TBD"
            outOf10.isHidden = true
        } else {
            playingMovieDetailRating.text = "\(movie.voteAverage)"
        }
        if hideTicketButton == true {
            ticketButton.isHidden = true
        }
        
        
        // Fetch/Set image for movie
        movieController.fetchMovieImage(movie: movie) { [weak self] (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self?.playingMovieDetailImage.image = image
            }
        }
        setImageViewShadow()
        updateTrailerButton()
        updateTicketButton()
    }
    
    // Drop Shadow for ImageView
    func setImageViewShadow() {
        playingMovieDetailImage.applyShadow()
//        playingMovieDetailImage.layer.shadowColor     = UIColor.black.cgColor
//        playingMovieDetailImage.layer.shadowOffset    = CGSize(width: 0.0, height: 9.0)
//        playingMovieDetailImage.layer.shadowRadius    = 5
//        playingMovieDetailImage.layer.shadowOpacity   = 0.5
    }
    
    // Make Trailer Button Round/Drop Shadow
    func updateTrailerButton() {
        playTrailerButton.setTitleColor(Colors.veryDarkGrey, for: .normal)
        playTrailerButton.setTitleColor(Colors.white, for: .highlighted)
        playTrailerButton.backgroundColor             = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        playTrailerButton.layer.cornerRadius          = playTrailerButton.frame.height / 2
        
        playTrailerButton.layer.shadowColor           = UIColor.black.cgColor
        playTrailerButton.layer.shadowOffset          = CGSize(width: 0.0, height: 6.0)
        playTrailerButton.layer.shadowOpacity         = 0.5
        playTrailerButton.layer.shadowRadius          = 8
    }
    
    // Make Ticket Button Round/Drop Shadow
    func updateTicketButton() {
        ticketButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        ticketButton.layer.cornerRadius = ticketButton.frame.height / 2
        
        ticketButton.layer.shadowOpacity = 0.5
        ticketButton.layer.shadowRadius = 8
        ticketButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        ticketButton.layer.shadowColor = UIColor.black.cgColor
    }
}

