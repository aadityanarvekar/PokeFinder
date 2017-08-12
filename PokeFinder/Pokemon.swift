//
//  Pokemon.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 8/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation

class Pokemon {
    private var _pokemonId: Int!
    var pokemonId: Int {
        return _pokemonId
    }
    
    private var _pokemonName: String!
    var pokemonName: String {
        return _pokemonName
    }
    
    init(id: Int, name: String) {
        self._pokemonId = id
        self._pokemonName = name
    }
    
}
