//
//  PokemonList.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 8/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import Foundation

class PokemonList {
    static var instance = PokemonList()
    private var _pokemonList: [Pokemon]! = []
    var pokemonList: [Pokemon] {
        return _pokemonList
    }
    
    private var _filteredPokemonList: [Pokemon] = []
    var filteredPokemonList: [Pokemon] {
        return _filteredPokemonList
    }
    
    
    func constructCompletePokemonList() {
        if _pokemonList.count == 0 {
            for i in 0 ..< pokemonArray.count {
                let pokemon = Pokemon(id: i + 1, name: pokemonArray[i])
                _pokemonList.append(pokemon)
            }
        }        
    }
    
    func filterPokemonList(bySearchString str: String) {
        _filteredPokemonList.removeAll()
        for i in 0 ..< pokemonArray.count {
            if pokemonArray[i].lowercased().range(of: str.lowercased()) != nil {
                let pokemon = Pokemon(id: i + 1, name: pokemonArray[i])
                _filteredPokemonList.append(pokemon)
            }
        }
    }
    
}
