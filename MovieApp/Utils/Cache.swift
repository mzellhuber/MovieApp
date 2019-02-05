//
//  Cache.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2019 mzellhuber. All rights reserved.
//


import UIKit
import Cache

class MovieCache: NSObject {
    static let shared = MovieCache()

    let listStorage = try! Storage(diskConfig: DiskConfig(name: "MovieListCache"),
                               memoryConfig: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10),
                               transformer: TransformerFactory.forCodable(ofType: [Movie].self))
    
    func saveListInCache(key:String, movies:[Movie]) {
        // Add objects to the cache
        do {
            try listStorage.setObject(movies, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func getListFromCache(key:String, completion: @escaping (_ movies: [Movie]?)->()) {

        // Try to fetch object from the cache
        listStorage.async.object(forKey: key) { result in
            switch result {
            case .value(let movies):
                //print(movies)
                completion(movies)
            case .error(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
