//
//  MiTableViewController.swift
//  pokemonRepaso
//
//  Created by user193642 on 3/1/22.
//

import UIKit

class MiTableViewController: UITableViewController {
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    
    var pokemons: [Pokemon?] = []
    var images: [UIImage?] = []
    let MAX_POKEMONS = 50
    var imagesDownload = 0
    var connection = Connection()
    //var isPreviousLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Pokemons"
        
        //deshabilitar el botón de borrado al principio
        deleteBarButtonItem.isEnabled = false
        
        //permitir selección múltiple mientras editamos
        tableView.allowsMultipleSelectionDuringEditing = true
        
        //if !isPreviousLoaded {
        pokemons = [Pokemon?](repeating: nil, count: MAX_POKEMONS)
        images = [UIImage?](repeating: nil, count: MAX_POKEMONS)
            
        downloadPokemonsInfo()
        //    isPreviousLoaded = true
        //}
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pokemons = [Pokemon?](repeating: nil, count: MAX_POKEMONS)
        images = [UIImage?](repeating: nil, count: MAX_POKEMONS)
        
        downloadPokemonsInfo()
    }*/

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPokemonCell", for: indexPath) as! MyCell

        // Configure the cell...
        //mostrar activity antes de cargar todos los pokemons
        if cell.activityPokemon.isAnimating {
            cell.nameCell.isHidden = true
            cell.imageCell.isHidden = true
        } else {
            cell.nameCell.isHidden = false
            cell.imageCell.isHidden = false
        }
        
        if let pokemon = pokemons[indexPath.row] {
            cell.nameCell.font = UIFont(name: "Pokemon Solid", size: 20)
            cell.nameCell.text = pokemon.name?.capitalized ?? "Desconocido"
            cell.nameCell.textColor = .red
        }
        
        if let image = images [indexPath.row] {
            cell.imageCell.image = image
            cell.activityPokemon.stopAnimating()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.performSegue(withIdentifier: "goToDetailSegue", sender: indexPath)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Swipe delete - borrar arrastrando a la izquierda
        if editingStyle == .delete {
            // Delete the row from the data source
            pokemons.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //Obtenemos los elementos que queremos cambiar de lugar
        let pokemonToMove = pokemons[fromIndexPath.row]
        let imageToMove = images[fromIndexPath.row]
        //Eliminarlos de donde están
        pokemons.remove(at: fromIndexPath.row)
        images.remove(at: fromIndexPath.row)
        //Los insertamos en el lugar que queremos que salgan
        pokemons.insert(pokemonToMove, at: to.row)
        images.insert(imageToMove, at: to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func downloadPokemonsInfo() {
        for i in 1...MAX_POKEMONS {
            connection.getPokemon(withId: i) { pokemon in
                if let pokemon = pokemon, let id = pokemon.id {
                    self.pokemons[id - 1] = pokemon
                    //obtenemos la imagen
                    if let image = pokemon.sprites?.frontDefault {
                        self.connection.getSprite(withURLString: image) { image in
                            self.imagesDownload = self.imagesDownload + 1
                            if let image = image {
                                self.images[id - 1] = image
                            }
                            if self.imagesDownload == self.MAX_POKEMONS {
                                DispatchQueue.main.async {
                                    //Una vez descargadas las imágenes lanzamos el refresco de la tabla
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController,
               let indexPath = tableView.indexPathForSelectedRow,
               let pokemon = pokemons[indexPath.row],
               let image = images[indexPath.row] {
                //pasamos los datos del pokemon
                detailVC.pokemonImage = image
                detailVC.pokemon = pokemon
            }
        }
    }

    @IBAction func setEditMode(_ sender: Any) {
        tableView.isEditing.toggle()
        editBarButtonItem.title = tableView.isEditing ? "Done" : "Edit"
        deleteBarButtonItem.isEnabled = tableView.isEditing
    }
    
    @IBAction func deleteRowsSelected(_ sender: Any) {
        //Obtenemos los items sleccionados
        if let selectedRows = tableView.indexPathsForSelectedRows {
            //Eliminar los seleccionados
            for indexPath in selectedRows {
                pokemons.remove(at: indexPath.row)
                images.remove(at: indexPath.row)
            }
            
            //Borrar las celdas
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    //Métodos de unwind oara recuperar datos del pokemon añadido o cancelar
    @IBAction func cancel(segue: UIStoryboardSegue) {
        //No hace nada
    }
    
    @IBAction func save(segue: UIStoryboardSegue) {
        //Guardar el pokémon
        //Recuperamos el pokemon y la imagen
        if let addVC = segue.source as? AddViewController,
           let newPokemon = addVC.pokemon,
           let newImage = addVC.image {
            //Añadirlos al a lista de pokemons y de imágenes, y refrescar la tabla
            pokemons.append(newPokemon)
            images.append(newImage)
            tableView.reloadData()
        }
    }
}
