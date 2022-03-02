//
//  AddViewController.swift
//  pokemonTaller
//
//  Created by user193642 on 3/2/22.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var pokemonNameTextField: UITextField!
    
    public var pokemon: Pokemon?
    public var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savePokemon" {
            savePokemon()
        }
    }
    
    func savePokemon() {
        if let pokemonName = pokemonNameTextField.text, !pokemonName.isEmpty {
            let newPokemon = Pokemon()
            newPokemon.name = pokemonName
            let newImage = UIImage(imageLiteralResourceName: "ticktick")
            self.pokemon = newPokemon
            self.image = newImage
        }
    }

}
