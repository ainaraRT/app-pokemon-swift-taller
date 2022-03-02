//
//  DetailViewController.swift
//  pokemonTaller
//
//  Created by user193642 on 3/2/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    public var pokemon: Pokemon?
    public var pokemonImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //si tenemos pokemon, pintamos el nombre y la imagen
        if let pokemon = pokemon {
            label.text = pokemon.name?.capitalized
        }
        if let pokemonImage = pokemonImage {
            imageView.image = pokemonImage
        }
        if let isDefault = pokemon?.isDefault {
            self.mySwitch.isOn = isDefault
            //Cambio del color del fondo si es default
            /*
            if isDefault {
                view.backgroundColor = .gray
            }*/
        }
    }

    @IBAction func shareName(_ sender: Any) {
        //Creamos los elementos a compartir, y tienen que ir siempre en un array de elementos
        let text = [self.label.text]
        
        //Creamos la vista de compartir
        let activityViewController = UIActivityViewController(activityItems: text as [Any], applicationActivities: nil)
        
        //Esto es para que funcione en iPads
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        //Excluir tipo de actividades
        activityViewController.excludedActivityTypes = [.airDrop, .postToFlickr, .postToFacebook]
        
        //Mostramos la pantalla
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        //Creamos los elementos a compartir, y tienen que ir siempre en un array de elementos
        let image = [self.imageView.image]
        
        //Creamos la vista de compartir
        let activityViewController = UIActivityViewController(activityItems: image as [Any], applicationActivities: nil)
        
        //Esto es para que funcione en iPads
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        //Excluir tipo de actividades
        activityViewController.excludedActivityTypes = [.postToFlickr, .postToFacebook]
        
        //Mostramos la pantalla
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
