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
    
    // MARK: - Usable data functions
    
    func loadAnnotationFromPlist() {
        var ndict: NSDictionary?
        let defaults = UserDefaults.standard
        
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
            ndict = NSDictionary(contentsOfFile: path)
            
            let places = ndict!["places"] as! [[String:Any]]
            defaults.set(places, forKey: "places")
            
            
            }
         else {
            print("Failed to load plist data of locations")
        }
    }
    
    func saveFavorites() {
        
    }
    
    func deleteFavorite() {
        
    }
    
    func listFavorites() {
        
    }
    
}
