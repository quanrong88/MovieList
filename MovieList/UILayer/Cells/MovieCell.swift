//
//  MovieCell.swift
//  
//
//  Created by Tạ Minh Quân on 19/03/2023.
//

import UIKit
import BusinessLogic
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var cellModel: MovieCellModel? {
        didSet {
            guard let cellModel = cellModel else {
                return
            }
            let url = URL(string: cellModel.movie.poster)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            movieTitleLabel.text = cellModel.movie.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
