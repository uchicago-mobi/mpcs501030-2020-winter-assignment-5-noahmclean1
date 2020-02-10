//
//  FavoritesViewController.swift
//  assignment 5
//
//  Created by Noah McLean on 2/9/20.
//  Copyright © 2020 Noah McLean. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var faveTable: UITableView!
    weak var delegate: PlacesFavoritesDelegate?
    let favorites = DataManager.sharedInstance.favorites
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        faveTable.delegate = self
        faveTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        faveTable.reloadData()
    }
    
    @IBAction func dismissPopover(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if let text = cell.textLabel?.text {
                delegate?.favoritePlace(name: text)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favorites[indexPath.row].name
        return cell
    }
}

protocol PlacesFavoritesDelegate: class {
    func favoritePlace(name: String) -> Void
}

