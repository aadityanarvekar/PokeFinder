//
//  PokeCell.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 8/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    func configureCell(pokemon: Pokemon) {
        pokemonImg.image = UIImage(named: "\(pokemon.pokemonId)")
        pokemonName.text = pokemon.pokemonName
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 7.5
        self.layer.masksToBounds = true
    }
    
}
