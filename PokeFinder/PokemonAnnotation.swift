//
//  PokemonAnnotation.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 7/29/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation

class PokemonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String? // Displayed on callout
    var pokeId: Int
    var pokeName: String
    
    init(coordinate: CLLocationCoordinate2D, pokeId: Int) {
        self.coordinate = coordinate
        self.pokeId = pokeId
        self.pokeName = pokemonArray[pokeId - 1].capitalized
        self.title = self.pokeName
    }
}
