//
//  DataManager.swift
//  assignment 5
//
//  Created by Noah McLean on 2/9/20.
//  Copyright © 2020 Noah McLean. All rights reserved.
//

import Foundation
import MapKit

public class DataManager {
    
    public static let sharedInstance = DataManager()
    
    fileprivate init() {}
    
    var favorites = [Place]()
    
    // MARK: - Usable data functions
    
    func loadAnnotationFromPlist() {
        var ndict: NSDictionary?
        let defaults = UserDefaults.standard
        var places = [[String:Any]]()
        
        
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
            ndict = NSDictionary(contentsOfFile: path)
            
            places = ndict!["places"] as! [[String:Any]]
            defaults.set(places, forKey: "places")
            
            
            }
         else {
            print("Failed to load plist data of locations")
        }
        
        
    }
    
    func saveFavorites() {
        let defaults = UserDefaults.standard
        
        var newlist = [[String : Any]]()
        
        for place in favorites {
            let placeD = [
                "name" : place.name!,
                "longDescription" : place.longDescription!,
                "coordlat": place.coordinate.latitude,
                "coordlon": place.coordinate.longitude
                ] as [String : Any]
            newlist.append(placeD)
        }
        
        defaults.set(newlist, forKey: "faves")
    }
    
    func deleteFavorite(name: String) {
        favorites = favorites.filter(){$0.name != name}
    }
    
    func listFavorites() {
        print(favorites)
    }
    
    func addFavorite(place: Place) {
        favorites.append(place)
    }
    
    func getFavorite(name: String) -> Place? {
        for place in favorites {
            if place.name! == name {
                return place
            }
        }
        return nil
    }
}
