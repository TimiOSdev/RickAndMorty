//
//  RickAndMortyCharViewCell.swift
//  Rick and Morty
//
//  Created by Tim on 9/29/20.
//  Copyright © 2020 Tim. All rights reserved.
//

import UIKit

class RickAndMortyCharViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageOutlet.image = nil
        
    }
}
