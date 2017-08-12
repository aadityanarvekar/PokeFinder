//
//  PokemonVC.swift
//  PokeFinder
//
//  Created by AADITYA NARVEKAR on 8/1/17.
//  Copyright © 2017 Aaditya Narvekar. All rights reserved.
//

import UIKit

protocol PokemonSelectedDelegate {
    func handlePokemonSelected(pokemon: Pokemon)
}

class PokemonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: PokemonSelectedDelegate?
    
    private var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardOnTapOutside()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        PokemonList.instance.constructCompletePokemonList()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if inSearchMode {
            poke = PokemonList.instance.filteredPokemonList[indexPath.row]
        } else {
            poke = PokemonList.instance.pokemonList[indexPath.row]
        }
        delegate?.handlePokemonSelected(pokemon: poke)
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return PokemonList.instance.filteredPokemonList.count
        }
        return PokemonList.instance.pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            var poke: Pokemon!            
            if inSearchMode {
                poke = PokemonList.instance.filteredPokemonList[indexPath.row]
            } else {
                poke = PokemonList.instance.pokemonList[indexPath.row]
            }
            cell.configureCell(pokemon: poke)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: 115)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search Started")
        inSearchMode = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search Ended")
        inSearchMode = (searchBar.text?.characters.count != 0)
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inSearchMode = searchText.characters.count != 0
        if inSearchMode {
            PokemonList.instance.filterPokemonList(bySearchString: searchText)
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
